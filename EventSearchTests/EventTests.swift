//
//  EventTests.swift
//  EventSearchTests
//
//  Created by Kevin Kinney on 10/19/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import XCTest
@testable import EventSearch

let eventJSON = """
{
	"taxonomies" : [
	{
	"id" : 1000000,
	"name" : "sports",
	"parent_id" : null
	},
	{
	"id" : 1070000,
	"name" : "golf",
	"parent_id" : 1000000
	}
	],
	"time_tbd" : true,
	"date_tbd" : false,
	"datetime_tbd" : false,
	"type" : "golf",
	"venue" : {
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
	"id" : 326529,
	"timezone" : "America\\/New_York",
	"popularity" : 0,
	"links" : [

	],
	"metro_code" : 0,
	"postal_code" : "23238",
	"url" : "https:\\/\\/seatgeek.com\\/venues\\/the-country-club-of-virginia\\/tickets"
	},
	"is_open" : false,
	"short_title" : "Dominion Energy Charity Classic - Friday First Round",
	"id" : 4401777,
	"title" : "Dominion Energy Charity Classic - Friday First Round",
	"url" : "https:\\/\\/seatgeek.com\\/dominion-energy-charity-classic-friday-first-round-tickets\\/golf\\/2018-10-19-3-30-am\\/4401777",
	"score" : 0,
	"performers" : [
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
	],
	"announce_date" : "2018-06-05T00:00:00",
	"visible_until_utc" : "2018-10-20T04:00:00",
	"description" : "",
	"stats" : {
		"highest_price" : null,
		"lowest_price_good_deals" : null,
		"dq_bucket_counts" : null,
		"median_price" : null,
		"lowest_price" : null,
		"visible_listing_count" : null,
		"listing_count" : null,
		"average_price" : null
	},
	"status" : "normal",
	"general_admission" : true,
	"access_method" : null,
	"popularity" : 0,
	"created_at" : "2018-06-05T16:00:52",
	"links" : [

	],
	"datetime_local" : "2018-10-19T03:30:00",
	"datetime_utc" : "2018-10-19T07:30:00"
}
"""

let eventPageJSON = """
{
	"meta" : {
		"geolocation" : null,
		"page" : 1,
		"took" : 7,
		"total" : 141885,
		"per_page" : 10
	},
	"events" : [
		\(eventJSON)
	]
}
"""

class EventTests: XCTestCase {
	
	func testDecodingEventFromJSON() {
		let data = eventJSON.data(using: .utf8)!
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-mm-dd'T'HH:mm:ss"
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		
		let venue = try! decoder.decode(Event.self, from: data)
		XCTAssertNotNil(venue, "unable to decode Event from valid JSON")
	}
	
	func testDecodingEventPageFromJSON() {
		let data = eventPageJSON.data(using: .utf8)!
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-mm-dd'T'HH:mm:ss"
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		
		let venue = try! decoder.decode(EventPage.self, from: data)
		XCTAssertNotNil(venue, "unable to decode Event from valid JSON")
	}
	
}
