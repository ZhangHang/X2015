//
//  NoteTimelineTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit
import X2015Kit

final class NoteTimelineTableViewController: FetchedResultTableViewController {

	var noteSearchTableViewController: NoteSearchTableViewController!
	var searchController: UISearchController!
	@IBOutlet weak var searchBar: UISearchBar!

	// From timeline or search result
	weak var selectedNote: Note?

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
				tableView(tableView, didDeselectRowAtIndexPath: indexPath)
			}
		}
		super.viewWillAppear(animated)
	}

	lazy var emptyNoteWelcomeView: EmptyNoteWelcomeView = {
		return EmptyNoteWelcomeView.instantiateFromNib()!
	}()

	override func updateThemeInterface(theme: Theme, animated: Bool) {
		super.updateThemeInterface(theme, animated: animated)
		func updateInterface() {
			emptyNoteWelcomeView.configureTheme(theme)
			searchController.searchBar.configureTheme(theme)
		}
		if animated {
			UIView.animateWithDuration(themeTransitionDuration, animations: updateInterface)
		} else {
			updateInterface()
		}
	}


	override func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
		guard let cell = cell as? NoteTableViewCell else {
			fatalError()
		}
		cell.configure(objectAt(indexPath))
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
		selectedNote = objectAt(indexPath) as Note
		performSegueWithIdentifier(NoteEditViewController.SegueIdentifier.Edit, sender: self)
	}


	override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		selectedNote = nil
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}

	override func tableView(
		tableView: UITableView,
		editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
			tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
			return [
				UITableViewRowAction(
					style: .Default,
					title: NSLocalizedString("Delete", comment: ""),
					handler: { [unowned self](action, indexPath) -> Void in
						let noteToDelete: Note = self.objectAt(indexPath)
						if noteToDelete == self.selectedNote {
							self.selectedNote = nil
						}
						self.managedObjectContext.deleteObject(self.objectAt(indexPath))
					})]
	}

	override func tableView(tableView: UITableView,
		willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
			if !self.splitViewController!.collapsed {
				self.performSegueWithIdentifier(
					NoteEditViewController.SegueIdentifier.Empty,
					sender: self)
			}
	}

	override func tableView(tableView: UITableView,
		didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
			updateNoteSelectionIfNeeded({ (indexPath) -> Void in
				if !self.splitViewController!.collapsed {
					self.performSegueWithIdentifier(
						NoteEditViewController.SegueIdentifier.Edit,
						sender: self)
				}
				}) { () -> Void in
					if !self.splitViewController!.collapsed {
						self.performSegueWithIdentifier(
							NoteEditViewController.SegueIdentifier.Empty,
							sender: self)
					}
			}
	}

}

extension NoteTimelineTableViewController {

	override func setupFetchedResultController() {
		fetchedResultsController = { [unowned self] in
			let fetchRequest = NSFetchRequest(entityName: Note.entityName)
			fetchRequest.sortDescriptors = Note.defaultSortDescriptors

			let fetchedResultsController = NSFetchedResultsController(
				fetchRequest: fetchRequest,
				managedObjectContext: self.managedObjectContext,
				sectionNameKeyPath: nil,
				cacheName: "NoteMaster")
			fetchedResultsController.delegate = self
			return fetchedResultsController
		}()

		({ [unowned self] in
			$0.backgroundView = self.emptyNoteWelcomeView
			$0.tableFooterView = UIView()
			$0.registerNib(
				UINib(nibName: NoteTableViewCell.nibName, bundle: nil),
				forCellReuseIdentifier: NoteTableViewCell.reusableIdentifier)
		})(tableView)
	}

	private var hasNote: Bool {
		return fetchedResultsController.fetchedObjects?.count > 0
	}

	func updateWelcomeViewVisibility() {
		tableView.backgroundView?.hidden = hasNote
	}

	func updateNoteSelectionIfNeeded(
		selectionChange: ((indexPath: NSIndexPath) -> Void)?,
		deselectAll: (() -> Void)? ) {
			if let selectedNote = selectedNote {
				let indexPath = fetchedResultsController.indexPathForObject(selectedNote)
				let currentSelectIndex = tableView.indexPathForSelectedRow
				if indexPath != currentSelectIndex && indexPath != nil {
					tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
					selectionChange?(indexPath: indexPath!)
				}
			} else if let selectedIndex = tableView.indexPathForSelectedRow {
				tableView.deselectRowAtIndexPath(selectedIndex, animated: true)
				deselectAll?()
			} else {
				// todo
			}
	}

	override func controllerDidChangeContent(controller: NSFetchedResultsController) {
		super.controllerDidChangeContent(controller)
		updateWelcomeViewVisibility()

		if splitViewController!.collapsed {
			return
		}

		updateNoteSelectionIfNeeded(nil) { [unowned self] () -> Void in
			self.performSegueWithIdentifier(
				NoteEditViewController.SegueIdentifier.Empty,
				sender: self)
		}
	}

}
