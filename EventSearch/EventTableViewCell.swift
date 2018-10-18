//
//  EventTableViewCell.swift
//  EventSearch
//
//  Created by Kevin Kinney on 10/16/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import Foundation
import UIKit

class EventTableViewCell: UITableViewCell {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var thumbnailImage: UIImageView!
	@IBOutlet weak var favoriteImage: UIImageView!
	
	override func prepareForReuse() {
		thumbnailImage.image = nil
	}
	
	func configure(withModel viewModel: EventViewModel) {
		titleLabel.text = viewModel.titleString
		locationLabel.text = viewModel.locationString
		dateLabel.text = viewModel.dateString
		thumbnailImage.image = viewModel.image
		thumbnailImage.layer.cornerRadius = 4
		favoriteImage.isHidden = !Favorites.isFavotire(viewModel.event.id)
	}
}
