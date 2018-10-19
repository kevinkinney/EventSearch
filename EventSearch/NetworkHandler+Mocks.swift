//
//  NetworkHandler+Mocks.swift
//  EventSearch
//
//  Created by Kevin Kinney on 10/19/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import Foundation
import OHHTTPStubs

// For testing purposes only, mock out the network requests.
#if TESTING
extension NetworkHandler {
	internal func stubNetworkRequests() {
		stub(condition: isHost("api.seatgeek.com")) { _ in
			let stubPath = OHPathForFile("mock_search_response.json", type(of: self))
			return fixture(filePath: stubPath!, headers: nil)
		}
		stub(condition: { (request) -> Bool in
			return request.url?.host != "api.seatgeek.com"
		}) { _ in
			let stubPath = OHPathForFile("image.png", type(of: self))
			return fixture(filePath: stubPath!, headers: nil)
		}
	}
}
#endif
