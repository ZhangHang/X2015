//
//  NoteTimelineTableViewController+Navigation.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteTimelineTableViewController {

	typealias NoteEditVCStoryboard = NoteEditViewController.Storyboard

	func handleNewNoteShortcut() {
		if let presentedViewController = navigationController?.presentedViewController
			where presentedViewController != self {
				navigationController!.dismissViewControllerAnimated(false, completion: nil)
		}

		// WORKAROUND BEGIN
		if navigationController!.topViewController != self {
			debugPrint("Workaround")
			navigationController!.popToViewController(self, animated: false)
			guard let vc = storyboard!
				.instantiateViewControllerWithIdentifier(NoteEditVCStoryboard.identifier)
				as? NoteEditViewController else {
					fatalError()
			}
			selectedNote = managedObjectContext.insertObject() as Note
			vc.noteActionMode = .Create(selectedNote!.objectID, managedObjectContext)

			navigationController?.pushViewController(vc, animated: false)
			return
		}
		// WORKAROUND END

		performSegueWithIdentifier(NoteEditVCStoryboard.SegueIdentifierCreateWithNoAnimation,
			sender: self)

	}

	@IBAction func insertNewNote(sender: UIBarButtonItem) {
		performSegueWithIdentifier(NoteEditVCStoryboard.SegueIdentifierCreate, sender: self)
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == NoteEditVCStoryboard.SegueIdentifierEdit {
			guard
				let nc = segue.destinationViewController as? UINavigationController,
				let vc = nc.childViewControllers.first as? NoteEditViewController,
				let selectedNote = self.selectedNote else {
					fatalError("Wrong edit-viewcontroller")
			}

			vc.noteActionMode = .Edit(selectedNote.objectID, managedObjectContext)
		}

		if segue.identifier == NoteEditVCStoryboard.SegueIdentifierCreate ||
			segue.identifier == NoteEditVCStoryboard.SegueIdentifierCreateWithNoAnimation {
				guard
					let nc = segue.destinationViewController as? UINavigationController,
					let vc = nc.childViewControllers.first as? NoteEditViewController else {
						fatalError("Wrong edit-viewcontroller")
				}

				selectedNote = managedObjectContext.insertObject() as Note
				vc.noteActionMode = .Create(selectedNote!.objectID, managedObjectContext)
		}
	}

}

extension NoteTimelineTableViewController {

	@IBAction func closeSettingsViewController(segue: UIStoryboardSegue) {}

}
