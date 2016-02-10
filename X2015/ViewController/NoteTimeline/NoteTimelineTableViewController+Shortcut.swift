//
//  NoteTimelineTableViewController+Shortcut.swift
//  X2015
//
//  Created by Hang Zhang on 2/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import X2015Kit

extension NoteTimelineTableViewController {

	func handleCreatingNoteShortcut() {
		backToTimeline({ [unowned self] () -> Void in
			self.performSegueWithIdentifier(NoteEditVCStoryboard.SegueIdentifierCreateWithNoAnimation,
				sender: self)
			}) { [unowned self] () -> Void in
				guard let vc = self.storyboard!
					.instantiateViewControllerWithIdentifier(NoteEditVCStoryboard.identifier)
					as? NoteEditViewController else {
						fatalError()
				}
				self.selectedNote = self.managedObjectContext.insertObject() as Note
				vc.noteActionMode = .Create(self.selectedNote!.objectID, self.managedObjectContext)

				self.navigationController?.pushViewController(vc, animated: false)
		}
	}

	func handleDisplayNoteShortcut(noteIdentifier identifier: String) {
		guard let note = Note.fetchNote(identifier, managedObjectContext: managedObjectContext) else {
			let alert = UIAlertController(
				title: NSLocalizedString("Error", comment: ""),
				message: NSLocalizedString("Note not found", comment: ""),
				preferredStyle: .Alert)
			let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (_) -> Void in
				self.dismissViewControllerAnimated(true, completion: nil)
			})
			alert.addAction(okAction)
			presentViewController(alert, animated: true, completion: nil)
			debugPrint("can't find note with identifier \(identifier)")
			return
		}

		selectedNote = note
		guard let indexPath = self.fetchedResultsController.indexPathForObject(note) else {
			fatalError()
		}

		backToTimeline({ [unowned self] () -> Void in
			self.performSegueWithIdentifier(NoteEditVCStoryboard.SegueIdentifierEditWithNoAnimation,
				sender: self)
			self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
			}) { [unowned self] () -> Void in
				guard
					let vc = self.storyboard!
					.instantiateViewControllerWithIdentifier(NoteEditVCStoryboard.identifier) as? NoteEditViewController,
					let selectedNote = self.selectedNote else {
						fatalError()
				}

				vc.noteActionMode = .Edit(selectedNote.objectID, self.managedObjectContext)
				self.navigationController?.pushViewController(vc, animated: false)

				self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
		}
	}

	func handleFocusOnSearchBarShortcut() {
		searchController.active = true
	}

	func handleSelectNextNoteShortcut() {
		debugPrint("handleSelectNextNoteShortcut")
		let noteCount = fetchedResultsController.fetchedObjects?.count ?? 0
		let selectionIndex = tableView.indexPathForSelectedRow?.row

		switch (selectionIndex, noteCount) {
		case (_, 0):
			return
		case (nil, _):
			selectNote(atRow: 0)
		case (let index?, _):
			selectNote(atRow: min(index + 1, noteCount - 1))
		}
	}

	func handleSelectPreviousNoteShortcut() {
		debugPrint("handleSelectPreviousNoteShortcut")
		let noteCount = fetchedResultsController.fetchedObjects?.count ?? 0
		let selectionIndex = tableView.indexPathForSelectedRow?.row

		switch (selectionIndex, noteCount) {
		case (_, 0):
			return
		case (nil, _):
			selectNote(atRow: 0)
		case (let index?, _):
			selectNote(atRow: max(index - 1, 0))
		}
	}

	private func selectNote(atRow row: Int) {
		let indexPath = NSIndexPath(forRow: row, inSection: 0)
		tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
		tableView(tableView, didSelectRowAtIndexPath: indexPath)
	}

}
