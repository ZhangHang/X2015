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
	private var emptyNoteWelcomeView: EmptyNoteWelcomeView = {
		return EmptyNoteWelcomeView.instantiateFromNib()
	}()!

	weak var delegate: NoteSearchTableViewControllerDelegate?

	// MARK: overrides

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.registerNib(
			UINib(nibName: NoteTableViewCell.nibName, bundle: nil),
			forCellReuseIdentifier: NoteTableViewCell.reusableIdentifier)
	}

	override func setupFetchedResultController() {
		fetchedResultsController = { [unowned self] in
			let fetchRequest = NSFetchRequest(entityName: Note.entityName)
			fetchRequest.sortDescriptors = Note.defaultSortDescriptors

			let fetchedResultsController = NSFetchedResultsController(
				fetchRequest: fetchRequest,
				managedObjectContext: self.managedObjectContext,
				sectionNameKeyPath: nil,
				cacheName: nil)
			fetchedResultsController.delegate = self
			return fetchedResultsController
		}()

		({[unowned self ] in
			$0.backgroundView = self.emptyNoteWelcomeView
			$0.tableFooterView = UIView()
			$0.registerNib(
				UINib(nibName: NoteTableViewCell.nibName, bundle: nil),
				forCellReuseIdentifier: NoteTableViewCell.reusableIdentifier)
		})(tableView)
	}

	override func tableView(
		tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
			if tableView != self.tableView {
				return UITableViewCell()
			}
			guard let cell = tableView.dequeueReusableCellWithIdentifier(
				NoteTableViewCell.reusableIdentifier,
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

	// MARK: Theme

	override func updateThemeInterface(theme: Theme, animated: Bool) {
		func updateInterface() {
			emptyNoteWelcomeView.configureTheme(theme)
		}

		if animated {
			UIView.animateWithDuration(themeTransitionDuration, animations: updateInterface)
		} else {
			updateInterface()
		}
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
			fetchedResultsController.fetchRequest.predicate = newPredicate
			fetchData()
			tableView.reloadData()
		}
	}

}
