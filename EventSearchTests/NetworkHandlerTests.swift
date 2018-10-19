//
//  NetworkHandlerTests.swift
//  EventSearchTests
//
//  Created by Kevin Kinney on 10/19/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import XCTest
import OHHTTPStubs
import Result
@testable import EventSearch

class NetworkHandlerTests: XCTestCase {
	
	let host = "api.seatgeek.com"
	
	func testRetrievingPageOfEventsWithValidJSON() {
		let requestStub = stub(condition: isHost(host)) { _ in
			let stubPath = OHPathForFile("mock_search_response.json", type(of: self))
			return fixture(filePath: stubPath!, headers: nil)
		}
		
		let expectation = self.expectation(description: "request completed")
		NetworkHandler.shared.requestEvents(forSearch: "test").onSuccess { page in
			XCTAssertFalse(page.events.isEmpty)
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 1.0) { _ in
			OHHTTPStubs.removeStub(requestStub)
		}
	}
	
	func testRetrievingPageOfEventsWithInvalidJSON() {
		let requestStub = stub(condition: isHost(host)) { _ in
			return OHHTTPStubsResponse(data: "{ \"foo\" : 1 }".data(using: .utf8)!, statusCode: 200, headers: nil)
		}
		
		let expectation = self.expectation(description: "request completed")
		NetworkHandler.shared.requestEvents(forSearch: "test").onFailure { _ in
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 1.0) { _ in
			OHHTTPStubs.removeStub(requestStub)
		}
	}
	
	func testRetrievingPageOfEventsWithFailedNetworkRequest() {
		let requestStub = stub(condition: isHost(host)) { _ in
			return OHHTTPStubsResponse(data: Data(), statusCode: 404, headers: nil)
		}
		
		let expectation = self.expectation(description: "request completed")
		NetworkHandler.shared.requestEvents(forSearch: "test").onFailure { _ in
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 1.0) { _ in
			OHHTTPStubs.removeStub(requestStub)
		}
	}
	
	func testRetrievingImageWithSuccessfulResponse() {
		let requestStub = stub(condition: isHost("test.com")) { _ in
			let stubPath = OHPathForFile("image.png", type(of: self))
			return fixture(filePath: stubPath!, headers: nil)
		}
		
		let expectation = self.expectation(description: "request completed")
		NetworkHandler.shared.downloadImage(URL(string: "http://test.com/myImage.jpg")!).onSuccess { image in
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 1.0) { _ in
			OHHTTPStubs.removeStub(requestStub)
		}
	}
	
	func testRetrievingImageWithFailedNetworkRequest() {
		let requestStub = stub(condition: isHost("test.com")) { _ in
			return OHHTTPStubsResponse(data: Data(), statusCode: 404, headers: nil)
		}
		
		let expectation = self.expectation(description: "request completed")
		NetworkHandler.shared.downloadImage(URL(string: "http://test.com/myImage.jpg")!).onFailure { _ in
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 1.0) { _ in
			OHHTTPStubs.removeStub(requestStub)
		}
	}
	
}
