//
//  Event.swift
//  EventSearch
//
//  Created by Kevin Kinney on 10/18/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import Foundation

struct EventPage: Decodable {
	let meta: Meta
	let events: [Event]
}

struct Meta: Decodable {
	let page: Int
	let total: Int
	let per_page: Int
}

struct Event: Decodable {
	let title: String
	let url: URL
	let datetime_local: Date
	let performers: [Performer]
	let venue: Venue
	let type: String
	let id: Int
}
