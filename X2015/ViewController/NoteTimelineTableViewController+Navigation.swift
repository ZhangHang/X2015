//
//  NoteTimelineTableViewController+Navigation.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteTimelineTableViewController {

	func handleNewNoteShortcut() {
		performSegueWithIdentifier(NoteEditViewController.Storyboard.SegueIdentifierCreate, sender: self)
	}

	@IBAction func insertNewNote(sender: UIBarButtonItem) {
		performSegueWithIdentifier(NoteEditViewController.Storyboard.SegueIdentifierCreate, sender: self)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == NoteEditViewController.Storyboard.SegueIdentifierEdit {
			guard
				let nc = segue.destinationViewController as? UINavigationController,
				let vc = nc.childViewControllers.first as? NoteEditViewController,
				let selectedNoteObjectID = self.selectedNoteObjectID else {
					fatalError("Wrong edit-viewcontroller")
			}

			vc.noteActionMode = .Edit(selectedNoteObjectID, managedObjectContext)
			vc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
			vc.navigationItem.leftItemsSupplementBackButton = true
		}

		if segue.identifier == NoteEditViewController.Storyboard.SegueIdentifierCreate {
			guard
				let nc = segue.destinationViewController as? UINavigationController,
				let vc = nc.childViewControllers.first as? NoteEditViewController else {
					fatalError("Wrong edit-viewcontroller")
			}
			let newNote: Note = self.managedObjectContext.insertObject()
			selectedNoteObjectID = newNote.objectID
			vc.noteActionMode = .Create(selectedNoteObjectID!, managedObjectContext)
			vc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
			vc.navigationItem.leftItemsSupplementBackButton = true
		}
	}

}

extension NoteTimelineTableViewController {

	@IBAction func closeSettingsViewController(segue: UIStoryboardSegue) {}

}
