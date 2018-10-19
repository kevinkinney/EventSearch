//
//  ViewController.swift
//  EventSearch
//
//  Created by Kevin Kinney on 10/16/18.
//  Copyright © 2018 Kevin Kinney. All rights reserved.
//

import UIKit

class EventListTableViewController: UITableViewController, UISearchBarDelegate {

	@IBOutlet weak var searchBar: UISearchBar!
	
	var eventViewModels = [EventViewModel]()
	var nextPage = 1
	var searchInProgress = false
	
	var searchRequestTimer: Timer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(favoriteUpdated(_:)), name: Favorites.favoriteUpdatedNotification, object: nil)
		
		loadNextPageForCurrentSearch()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	func clearSearchResults() {
		nextPage = 1
		eventViewModels.removeAll()
		tableView.reloadData()
	}
	
	func loadNextPageForCurrentSearch() {
		guard let searchText = searchBar.text else {
			return
		}
		searchInProgress = true
		NetworkHandler.shared.requestEvents(forSearch: searchText, page: nextPage).onSuccess { page in
			let newEventViewModels = page.events.map { EventViewModel(event: $0) }
			self.nextPage += 1
			self.eventViewModels.append(contentsOf: newEventViewModels)
			self.searchInProgress = false
			self.tableView.reloadData()
		}
	}
	
	func retrieveImageIfNeeded(forViewModel viewModel: EventViewModel) {
		guard viewModel.image == nil else {
			return
		}
		guard let imageURL = getFirstPerformerImageURL(forEvent: viewModel.event) else {
			return
		}
		NetworkHandler.shared.downloadImage(imageURL).onSuccess { image in
			if let row = self.eventViewModels.index(where: {$0.event.id == viewModel.event.id}) {
				viewModel.image = image
				let indexPathToReload = IndexPath(row: row, section: 0)
				self.tableView.reloadRows(at: [indexPathToReload], with: .fade)
			}
		}
	}
	
	func getFirstPerformerImageURL(forEvent event: Event) -> URL? {
		guard let urlString = event.performers.compactMap({$0.image}).first else {
			return nil
		}
		return URL(string: urlString)
	}
	
	@objc
	func favoriteUpdated(_ notification: Notification) {
		tableView.reloadData()
	}
	
	// MARK: - UISearchBarDelegate
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		// Use a timer to verify that the user has stopped typing for at least 0.5 seconds.
		searchRequestTimer?.invalidate()
		searchRequestTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
			self.clearSearchResults()
			self.loadNextPageForCurrentSearch()
		}
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.text = ""
		clearSearchResults()
		searchBar.resignFirstResponder()
		loadNextPageForCurrentSearch()
	}
	
	// MARK: - UIScrollViewDelegate
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		searchBar.resignFirstResponder()
	}
	
	override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		
		let contentHeightOffset = scrollView.contentOffset.y
		let maxOffset = scrollView.frame.size.height - scrollView.contentSize.height
		
		let scrolledToEnd = contentHeightOffset >= maxOffset
		
		if scrolledToEnd {
			loadNextPageForCurrentSearch()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "ShowEventDetails",
			let eventViewController = segue.destination as? EventViewController,
			let selectedIndexPath = tableView.indexPathForSelectedRow else {
			return
		}
		eventViewController.eventViewModel = eventViewModels[selectedIndexPath.row]
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: "ShowEventDetails", sender: self)
	}
	
	// MARK: - UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// If there are no matches to the current search a single row is displayed stating that there were no results
		if eventViewModels.count == 0 && !searchInProgress {
			return 1
		} else {
			return eventViewModels.count
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if eventViewModels.isEmpty {
			return tableView.dequeueReusableCell(withIdentifier: "NoResultsTableViewCell", for: indexPath)
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
				return UITableViewCell()
			}
			
			let eventViewModel = eventViewModels[indexPath.row]
			retrieveImageIfNeeded(forViewModel: eventViewModel)
			
			cell.configure(withModel: eventViewModel)
			
			return cell
		}
	}
}

