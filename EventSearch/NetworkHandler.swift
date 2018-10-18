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
import SwiftyJSON

struct Event {
	let title: String
	let URL: URL
	let date: Date
	let performers: [Performer]
	let venue: Venue
	let type: String
	let id: Int
	
	init?(json: JSON) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-mm-dd'T'HH:mm:ss"
		guard let title = json["title"].string,
			let id = json["id"].int,
			let URL = json["url"].url,
			let dateString = json["datetime_local"].string,
			let date = dateFormatter.date(from: dateString),
			let type = json["type"].string,
			let venue = Venue(json: json["venue"]),
			let performersJSON = json["performers"].array else {
				
				NSLog("failed to serialize Event from JSON: \(json)")
				return nil
		}
		
		let performers = performersJSON.compactMap({ Performer(json: $0) })
		guard performers.count > 0 else {
			return nil
		}
		
		self.title = title
		self.id = id
		self.URL = URL
		self.date = date
		self.type = type
		self.venue = venue
		self.performers = performers
	}
}

struct Performer {
	let name: String
	let id: Int
	let imageURL: URL?
	
	init?(json: JSON) {
		guard let name = json["name"].string,
		let id = json["id"].int else {
			
			NSLog("failed to serialize Performer from JSON: \(json)")
			return nil
		}
		self.imageURL = json["image"].url
		self.name = name
		self.id = id
	}
}

struct Venue {
	let city: String
	let state: String
	
	init?(json: JSON) {
		guard let city = json["city"].string,
			let state = json["state"].string else {
			
			NSLog("failed to serialize Venue from JSON: \(json)")
			return nil
		}
		self.city = city
		self.state = state
	}
}

class NetworkHandler {
	
	static let shared = NetworkHandler()
	
	private let clientId = "MTM1NzY3MDJ8MTUzOTcxMTk3MC41Mw"
	private let secret = "6ff0b6f1323af012c882a23f9d9d01a13f658800c4d265526e3e30a21c0f772a"
	
	private let sessionManager: SessionManager
	
	// Make the initializer private to force use of the singleton version of this class.
	private init() {
		
		// Create a custom configuration for the session that includes the authentication headers by default
		let configuration = URLSessionConfiguration.default
		let credentials = "\(clientId):\(secret)"
		let base64EncodedCredentials = credentials.data(using: String.Encoding.utf8)!.base64EncodedString()
		let authorizationHeaders = ["Authorization": "Basic \(base64EncodedCredentials)"]
		configuration.httpAdditionalHeaders = authorizationHeaders
		
		sessionManager = SessionManager(configuration: configuration)
	}
	
	func requestEvents(forSearch searchString: String, page: Int? = nil) -> Future<[Event], NSError> {
		
		let promise = Promise<[Event], NSError>()
		
		var parameters = Parameters()
		if !searchString.isEmpty {
			parameters["q"] = searchString
		}
		if let requestedPage = page {
			parameters["page"] = requestedPage
		}
		sessionManager.request("https://api.seatgeek.com/2/events", parameters: parameters).responseJSON { response in
			switch response.result {
			case.success(let data):
				let jsonEvents = JSON(data)["events"].array ?? []
				let events = jsonEvents.compactMap({ Event(json: $0) })
				promise.success(events)
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
				promise.success(UIImage(data: data)!) // TODO: remove force unwrapping
			case .failure(let error):
				promise.failure(error as NSError)
			}
			
		}
		
		return promise.future
	}
}
