//
//  VenueTests.swift
//  EventSearchTests
//
//  Created by Kevin Kinney on 10/19/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import XCTest
@testable import EventSearch

let venueJSON =
"""
{
	"country" : "US",
	"city" : "Richmond",
	"name" : "The Country Club of Virginia",
	"score" : 0,
	"state" : "VA",
	"address" : "709 S. Gaskins Road",
	"display_location" : "Richmond, VA",
	"has_upcoming_events" : true,
	"num_upcoming_events" : 1,
	"name_v2" : "The Country Club of Virginia",
	"extended_address" : "Richmond, VA 23238",
	"location" : {
		"lat" : 37.57,
		"lon" : -77.609999999999999
	},
	"access_method" : null,
	"slug" : "the-country-club-of-virginia",
	"timezone" : "America\\/New_York",
	"id" : 326529,
	"popularity" : 0,
	"links" : [

	],
	"metro_code" : 0,
	"postal_code" : "23238",
	"url" : "https:\\/\\/seatgeek.com\\/venues\\/the-country-club-of-virginia\\/tickets"
}
"""

class VenueTests: XCTestCase {
	func testDecodingVenueFromJSON() {
		let data = venueJSON.data(using: .utf8)!
		let venue = try? JSONDecoder().decode(Venue.self, from: data)
		XCTAssertNotNil(venue, "unable to decode Venue from valid JSON")
	}
}
