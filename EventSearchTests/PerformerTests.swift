//
//  PerformerTests.swift
//  EventSearchTests
//
//  Created by Kevin Kinney on 10/19/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import XCTest
@testable import EventSearch

let performerJSON = """
{
	"name" : "Dominion Energy Charity Classic",
	"taxonomies" : [
		{
			"document_source" : {
			"source_type" : "ELASTIC",
			"generation_type" : "FULL"
		},
			"name" : "sports",
			"parent_id" : null,
			"id" : 1000000
		},
		{
			"document_source" : {
			"source_type" : "ELASTIC",
			"generation_type" : "FULL"
		},
			"name" : "golf",
			"parent_id" : 1000000,
			"id" : 1070000
		}
	],
	"score" : 0,
	"divisions" : null,
	"short_name" : "Dominion Energy Charity Classic",
	"image_attribution" : null,
	"home_venue_id" : null,
	"has_upcoming_events" : true,
	"colors" : null,
	"image_license" : null,
	"type" : "golf",
	"stats" : {
		"event_count" : 1
	},
	"num_upcoming_events" : 1,
	"location" : null,
	"popularity" : 0,
	"slug" : "dominion-energy-charity-classic",
	"image" : null,
	"id" : 530003,
	"primary" : true,
	"images" : {

	},
	"url" : "https:\\/\\/seatgeek.com\\/dominion-energy-charity-classic-tickets"
}
"""

class PerformerTests: XCTestCase {
    
	func testDecodingPerformerFromJSON() {
		let data = performerJSON.data(using: .utf8)!
		let venue = try! JSONDecoder().decode(Performer.self, from: data)
		XCTAssertNotNil(venue, "unable to decode Performer from valid JSON")
	}
    
}
