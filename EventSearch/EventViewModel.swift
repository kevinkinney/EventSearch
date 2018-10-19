//
//  EventViewModel.swift
//  EventSearch
//
//  Created by Kevin Kinney on 10/17/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import Foundation
import UIKit

class EventViewModel {
	
	let event: Event
	var image: UIImage? = nil
	
	private let dateFormatter: DateFormatter
	
	init(event: Event) {
		self.event = event
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		self.dateFormatter = dateFormatter
	}
	
	var titleString: String {
		return event.title
	}
	
	var dateString: String {
		return dateFormatter.string(from: event.datetime_local)
	}
	
	var locationString: String {
		return "\(event.venue.city), \(event.venue.state)"
	}
}
