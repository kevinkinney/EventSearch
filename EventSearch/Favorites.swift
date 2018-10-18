//
//  Favorites.swift
//  EventSearch
//
//  Created by Kevin Kinney on 10/17/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import Foundation

class Favorites {
	
	private static let favoritesArrayKey = "event_favorites"
	static let favoriteUpdatedNotification = NSNotification.Name("favorite_updated")
	
	static func toggleFavorite(_ uid: Int)  {
		var favoritesArray: [Int] = (UserDefaults.standard.array(forKey: Favorites.favoritesArrayKey) as? [Int]) ?? []
		var isFavorite = true
		if let indexToRemove = favoritesArray.index(where: {$0 == uid}) {
			favoritesArray.remove(at: indexToRemove)
			isFavorite = false
		} else {
			favoritesArray.append(uid)
		}
		UserDefaults.standard.setValue(favoritesArray, forKey: Favorites.favoritesArrayKey)
		NotificationCenter.default.post(name: Favorites.favoriteUpdatedNotification, object: nil, userInfo: [uid: isFavorite])
	}
	
	static func isFavotire(_ uid: Int) -> Bool {
		let favoritesArray: [Int] = (UserDefaults.standard.array(forKey: Favorites.favoritesArrayKey) as? [Int]) ?? []
		return favoritesArray.contains(uid)
	}
}
