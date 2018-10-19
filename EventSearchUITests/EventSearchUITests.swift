//
//  EventSearchUITests.swift
//  EventSearchUITests
//
//  Created by Kevin Kinney on 10/16/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import XCTest

class EventSearchUITests: XCTestCase {

    override func setUp() {
		super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testViewingEvent() {
		let app = XCUIApplication()
		
		// Open an event
		app.tables.staticTexts["Eiffel Tower Experience"].tap()
		
		// Test using the favorites button
		let deselectAsFavorite = app.buttons["Deselect as Favorite"]
		let selectAsFavotire = app.buttons["Select as Favorite"]
		if deselectAsFavorite.exists {
			// Make sure the favorites button is unselected
			deselectAsFavorite.tap()
		}
		selectAsFavotire.tap()
		XCTAssertTrue(deselectAsFavorite.exists)
		
		// Hit the back button if not in a split view
		if app.navigationBars["EventSearch.EventView"].buttons["Back"].exists {
			app.navigationBars["EventSearch.EventView"].buttons["Back"].tap()
		}
		
		// Check that item is favorited in the list
		XCTAssertTrue(app.images["favorite"].exists)
	}
}
