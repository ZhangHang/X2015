//
//  NoteTimelineTableViewController+Route.swift
//  X2015
//
//  Created by Hang Zhang on 2/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import X2015Kit

extension NoteTimelineTableViewController {

	func handleCreatingNoteRequest() {
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

	func handleDisplayNoteRequest(noteIdentifier identifier: String) {
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
}
