//
//  NetworkHandler.swift
//  EventSearch
//
//  Created by Kevin Kinney on 10/16/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import Foundation
import Alamofire
import BrightFutures

class NetworkHandler {
	
	static let shared = NetworkHandler()
	
	private let clientId = "MTM1NzY3MDJ8MTUzOTcxMTk3MC41Mw"
	private let secret = "6ff0b6f1323af012c882a23f9d9d01a13f658800c4d265526e3e30a21c0f772a"
	
	private let sessionManager: SessionManager
	
	// This is lazy so that it is only created once.
	lazy var decoder: JSONDecoder = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-mm-dd'T'HH:mm:ss"
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		return decoder
	}()
	
	// Make the initializer private to force use of the singleton version of this class.
	private init() {
		// Create a custom configuration for the session that includes the authentication headers by default
		let configuration = URLSessionConfiguration.default
		let credentials = "\(clientId):\(secret)"
		let base64EncodedCredentials = credentials.data(using: String.Encoding.utf8)!.base64EncodedString()
		let authorizationHeaders = ["Authorization": "Basic \(base64EncodedCredentials)"]
		configuration.httpAdditionalHeaders = authorizationHeaders
		
		sessionManager = SessionManager(configuration: configuration)
		
		#if TESTING
			stubNetworkRequests()
		#endif
	}
	
	func requestEvents(forSearch searchString: String, page: Int? = nil) -> Future<EventPage, NSError> {
		
		let promise = Promise<EventPage, NSError>()
		
		var parameters = Parameters()
		if !searchString.isEmpty {
			parameters["q"] = searchString
		}
		if let requestedPage = page {
			parameters["page"] = requestedPage
		}
		sessionManager.request("https://api.seatgeek.com/2/events", parameters: parameters).responseData { response in
			switch response.result {
			case.success(let data):
				do {
					let page = try self.decoder.decode(EventPage.self, from: data)
					promise.success(page)
				} catch {
					NSLog("unable to decode JSON \(error)")
					promise.failure(NSError(domain: "EventSearchNetworkHandler", code: 1, userInfo: nil))
				}
			case.failure(let error):
				promise.failure(error as NSError)
			}
		}
		
		return promise.future
	}
	
	func downloadImage(_ url: URL) -> Future<UIImage, NSError> {
		
		let promise = Promise<UIImage, NSError>()
		
		sessionManager.request(url, headers: nil).responseData { response in
			switch response.result {
			case .success(let data):
				if let image = UIImage(data: data) {
					promise.success(image)
				} else {
					NSLog("unable to create image from response data")
					promise.failure(NSError(domain: "EventSearchNetworkHandler", code: 1, userInfo: nil))
				}
			case .failure(let error):
				promise.failure(error as NSError)
			}
			
		}
		
		return promise.future
	}
}
