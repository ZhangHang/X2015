//
//  NoteSearchTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/21/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

protocol NoteSearchTableViewControllerDelegate: class {

	func noteSearchTableViewController(
		controller: NoteSearchTableViewController,
		didSelectNoteID noteObjectID: NSManagedObjectID)

}

class NoteSearchTableViewController: FetchedResultTableViewController {

	private var keywordCache: String?
	private var searchPredicate: NSPredicate?

	weak var delegate: NoteSearchTableViewControllerDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.registerNib(
			UINib(nibName: NoteTableViewCell.nibName, bundle: nil),
			forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
	}

	override func setupFetchedResultController() {
		let fetchRequest = NSFetchRequest(entityName: Note.entityName)
		fetchRequest.sortDescriptors = Note.defaultSortDescriptors

		fetchedResultsController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: managedObjectContext,
			sectionNameKeyPath: nil,
			cacheName: nil)
		fetchedResultsController.delegate = self
		tableView.backgroundView = EmptyNoteWelcomeView.instantiateFromNib()
		tableView.tableFooterView = UIView()
		tableView.registerNib(
			UINib(nibName: NoteTableViewCell.nibName, bundle: nil),
			forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
	}

	override func tableView(
		tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
			if tableView != self.tableView {
				return UITableViewCell()
			}
			guard let cell = tableView.dequeueReusableCellWithIdentifier(
				NoteTableViewCell.reuseIdentifier,
				forIndexPath: indexPath) as? NoteTableViewCell else {
					fatalError("Wrong table view cell type")
			}
			cell.configure(objectAt(indexPath) as Note)
			return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		delegate?.noteSearchTableViewController(self,
			didSelectNoteID: (objectAt(indexPath) as Note).objectID)
	}
}

extension NoteSearchTableViewController {

	func search(keyword: String?) {
		if keywordCache == keyword {
			return
		}
		keywordCache = keyword
		if let keyword = keyword {
			let newPredicate =  NSPredicate(format: "content CONTAINS[cd] %@", keyword)
			debugPrint("Filter notes with predicate \(newPredicate)")
			fetchedResultsController.fetchRequest.predicate = newPredicate
			fetchData()
			tableView.reloadData()
		}
	}

}
