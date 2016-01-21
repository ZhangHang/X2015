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
		setupFetchedResultController()
		setupSearchController()
		registerForPreviewing()
	}

	override func viewWillAppear(animated: Bool) {
		updateWelcomeViewVisibility()
		super.viewWillAppear(animated)
	}

}

extension NoteTimelineTableViewController {

	override func setupFetchedResultController() {
		let fetchRequest = NSFetchRequest(entityName: Note.entityName)
		fetchRequest.sortDescriptors = Note.defaultSortDescriptors

		fetchedResultController = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: managedObjectContext,
			sectionNameKeyPath: nil,
			cacheName: nil)
		fetchedResultController.delegate = self
		tableView.backgroundView = EmptyNoteWelcomeView.instantiateFromNib()
		tableView.tableFooterView = UIView()
		tableView.registerNib(
			UINib(nibName: NoteTableViewCell.nibName, bundle: nil),
			forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
	}

}

extension NoteTimelineTableViewController {

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
		cell.configure(noteAt(indexPath))
		return cell
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
							self.managedObjectContext.deleteObject(self.noteAt(indexPath))
							})
					})]
	}

}

extension NoteTimelineTableViewController {

	func noteAt(indexPath: NSIndexPath) -> Note {
		return objectAt(indexPath)
	}

}

extension NoteTimelineTableViewController {

	func updateWelcomeViewVisibility() {
		if fetchedResultController.fetchedObjects?.count == 0 {
			tableView.backgroundView?.hidden = false
		} else {
			tableView.backgroundView?.hidden = true
		}
	}

}

extension NoteTimelineTableViewController {

	func handleNewNoteShortcut() {
		performSegueWithIdentifier(NoteEditViewController.SegueIdentifier.Create.identifier(), sender: self)
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedNoteObjectID = noteAt(indexPath).objectID
		performSegueWithIdentifier(NoteEditViewController.SegueIdentifier.Edit.identifier(), sender: self)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let identifier = segue.identifier else {
			fatalError("No segue identifier found")
		}

		switch identifier {
		case NoteEditViewController.SegueIdentifier.Edit.identifier():
			guard
				let vc = segue.destinationViewController as? NoteEditViewController,
				let _ = self.selectedNoteObjectID else {
					fatalError("Wrong edit-viewcontroller")
			}

			vc.managedObjectContext = managedObjectContext
			vc.setup(managedObjectContext, exsitingNoteID: selectedNoteObjectID)
			break
		case NoteEditViewController.SegueIdentifier.Create.identifier():
			guard let vc = segue.destinationViewController as? NoteEditViewController else {
				fatalError("Wrong edit-viewcontroller")
			}
			vc.setup(managedObjectContext)
			break
		default:
			break
		}
	}

}
