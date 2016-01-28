//
//  NoteTimelineTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

final class NoteTimelineTableViewController: FetchedResultTableViewController {

	var noteSearchTableViewController: NoteSearchTableViewController!
	var searchController: UISearchController!
	@IBOutlet weak var searchBar: UISearchBar!

	// From timeline or search result
	var selectedNoteObjectID: NSManagedObjectID?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSearchController()
		registerForPreviewing()
	}

	override func viewWillAppear(animated: Bool) {
		updateWelcomeViewVisibility()
		clearsSelectionOnViewWillAppear = splitViewController!.collapsed
		if clearsSelectionOnViewWillAppear {
			if let indexPath = tableView.indexPathForSelectedRow {
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
			}
		}
		super.viewWillAppear(animated)
	}

	lazy var emptyNoteWelcomeView: EmptyNoteWelcomeView = {
		return EmptyNoteWelcomeView.instantiateFromNib()!
	}()

	override func updateThemeInterface(theme: Theme) {
		super.updateThemeInterface(theme)
		emptyNoteWelcomeView.configureTheme(theme)
	}

}

extension NoteTimelineTableViewController {

	override func tableView(
		tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
			guard let cell: NoteTableViewCell = tableView.dequeueReusableCell(indexPath) else {
				fatalError()
			}
			cell.configure(objectAt(indexPath))
			cell.configureTheme(currentTheme)
			return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedNoteObjectID = objectAt(indexPath).objectID
		performSegueWithIdentifier(NoteEditViewController.Storyboard.SegueIdentifierEdit, sender: self)
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}

	override func tableView(
		tableView: UITableView,
		editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
			return [
				UITableViewRowAction(
					style: .Default,
					title: NSLocalizedString("Delete", comment: ""),
					handler: { [unowned self](action, indexPath) -> Void in
						self.managedObjectContext.performChanges({ [unowned self] () -> () in
							self.managedObjectContext.deleteObject(self.objectAt(indexPath))
							})
					})]
	}

}

extension NoteTimelineTableViewController {

	override func setupFetchedResultController() {
		let fetchRequest = NSFetchRequest(entityName: Note.entityName)
		fetchRequest.sortDescriptors = Note.defaultSortDescriptors

		fetchedResultsController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: managedObjectContext,
			sectionNameKeyPath: nil,
			cacheName: "NoteMaster")
		fetchedResultsController.delegate = self
		tableView.backgroundView = emptyNoteWelcomeView
		tableView.tableFooterView = UIView()
		tableView.registerNib(
			UINib(nibName: NoteTableViewCell.nibName, bundle: nil),
			forCellReuseIdentifier: NoteTableViewCell.reusableIdentifier)
	}

	func updateWelcomeViewVisibility() {
		let hideBackground = fetchedResultsController.fetchedObjects?.count > 0
		tableView.backgroundView?.hidden = hideBackground
	}


	override func controllerDidChangeContent(controller: NSFetchedResultsController) {
		updateWelcomeViewVisibility()
		super.controllerDidChangeContent(controller)
		if fetchedResultsController.fetchedObjects?.count == 0 && !splitViewController!.collapsed {
			performSegueWithIdentifier(
				NoteEditViewController.Storyboard.SegueIdentifierEmpty,
				sender: self)
		} else if let noteObjectID = selectedNoteObjectID {
			let selectedNote = managedObjectContext.objectWithID(noteObjectID)
			let indexPath = fetchedResultsController.indexPathForObject(selectedNote)
			tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
		}
	}
}
