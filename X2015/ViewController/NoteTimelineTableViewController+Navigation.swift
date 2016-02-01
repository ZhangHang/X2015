//
//  NoteTimelineTableViewController+Navigation.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import X2015Kit

extension NoteTimelineTableViewController {

	typealias NoteEditVCStoryboard = NoteEditViewController.Storyboard


	private func backToTimeline(
		completion: (() -> Void)?,
		workaround: (() -> Void)? ) {
		if let presentedViewController = navigationController?.presentedViewController
			where presentedViewController != self {
				navigationController!.dismissViewControllerAnimated(false, completion: nil)
		}

		// WORKAROUND BEGIN
		if navigationController!.topViewController != self {
			debugPrint("Workaround")
			navigationController!.popToViewController(self, animated: false)
			workaround?()
			return
		}
		// WORKAROUND END

		completion?()
	}

	func handleNewNoteShortcut() {
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

	func handleEditNoteUserActivity(noteIdentifier identifier: String) {
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

		backToTimeline({ [unowned self] () -> Void in
			self.performSegueWithIdentifier(NoteEditVCStoryboard.SegueIdentifierEditWithNoAnimation,
				sender: self)
			}) { [unowned self] () -> Void in
				guard let vc = self.storyboard!
					.instantiateViewControllerWithIdentifier(NoteEditVCStoryboard.identifier)
					as? NoteEditViewController else {
						fatalError()
				}

				vc.noteActionMode = .Edit(self.selectedNote!.objectID, self.managedObjectContext)
				self.navigationController?.pushViewController(vc, animated: false)
		}
	}

	@IBAction func insertNewNote(sender: UIBarButtonItem) {
		performSegueWithIdentifier(NoteEditVCStoryboard.SegueIdentifierCreate, sender: self)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		guard let identifier = segue.identifier else {
			return
		}

		switch identifier {
		case NoteEditVCStoryboard.SegueIdentifierCreate, NoteEditVCStoryboard.SegueIdentifierCreateWithNoAnimation:
			guard
				let nc = segue.destinationViewController as? UINavigationController,
				let vc = nc.childViewControllers.first as? NoteEditViewController else {
					fatalError("Wrong edit-viewcontroller")
			}

			selectedNote = managedObjectContext.insertObject() as Note
			vc.noteActionMode = .Create(selectedNote!.objectID, managedObjectContext)
		case NoteEditVCStoryboard.SegueIdentifierEdit, NoteEditVCStoryboard.SegueIdentifierEditWithNoAnimation:
			guard
				let nc = segue.destinationViewController as? UINavigationController,
				let vc = nc.childViewControllers.first as? NoteEditViewController,
				let selectedNote = self.selectedNote else {
					fatalError("Wrong edit-viewcontroller")
			}

			vc.noteActionMode = .Edit(selectedNote.objectID, managedObjectContext)
		case NoteEditVCStoryboard.SegueIdentifierEmpty:
			break
		default:
			return
		}
	}

}

extension NoteTimelineTableViewController {

	@IBAction func closeSettingsViewController(segue: UIStoryboardSegue) {}
	
}
