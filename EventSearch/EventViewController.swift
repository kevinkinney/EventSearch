//
//  EventViewController.swift
//  EventSearch
//
//  Created by Kevin Kinney on 10/16/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import Foundation
import UIKit

class EventViewController: UIViewController {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var imageUnavailableLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var favoriteButton: UIButton!
	
	var eventViewModel: EventViewModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
			
		titleLabel.text = eventViewModel?.titleString
		locationLabel.text = eventViewModel?.locationString
		dateLabel.text = eventViewModel?.dateString
		
		if let image = eventViewModel?.image {
			imageView.image = image
			imageUnavailableLabel.isHidden = true
		} else {
			imageUnavailableLabel.isHidden = false
		}
		imageView.layer.cornerRadius = 6
		
		updateFavoritesButton()
	}
	
	func updateFavoritesButton() {
		guard let eventId = eventViewModel?.event.id else {
			return
		}
		if Favorites.isFavotire(eventId) {
			favoriteButton.setImage(#imageLiteral(resourceName: "favorite"), for: .normal)
			favoriteButton.accessibilityLabel = "Deselect as Favorite"
		} else {
			favoriteButton.setImage(#imageLiteral(resourceName: "favorite_unselected"), for: .normal)
			favoriteButton.accessibilityLabel = "Select as Favorite"
		}
	}
	
	@IBAction func favoriteButtonPressed(_ button: UIButton) {
		guard let eventId = eventViewModel?.event.id else {
			return
		}
		Favorites.toggleFavorite(eventId)
		updateFavoritesButton()
	}
}
