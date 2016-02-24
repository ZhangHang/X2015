//
//  NoteTimelineTableViewController+ UIViewControllerPreviewingDelegate.swift
//  X2015
//
//  Created by Hang Zhang on 1/21/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import X2015Kit

extension NoteTimelineTableViewController: UIViewControllerPreviewingDelegate {

	func registerForPreviewing() {
		registerForPreviewingWithDelegate(self, sourceView: view)
	}

	func previewingContext(
		previewingContext: UIViewControllerPreviewing,
		viewControllerForLocation location: CGPoint) -> UIViewController? {
			guard let indexPath = tableView.indexPathForRowAtPoint(location),
				cell = tableView.cellForRowAtIndexPath(indexPath) else { return nil }

			guard let detailViewController = NoteEditViewController.instanceFromStoryboard() else { return nil }

			let previewNote: Note = objectAt(indexPath)
			detailViewController.editingMode = .Edit(previewNote.objectID, managedObjectContext)
			detailViewController.delegate = self

			previewingContext.sourceRect = cell.frame

			return detailViewController
	}

	func previewingContext(
		previewingContext: UIViewControllerPreviewing,
		commitViewController viewControllerToCommit: UIViewController) {
			showViewController(viewControllerToCommit, sender: self)
	}

}

extension NoteTimelineTableViewController: NoteEditViewControllerDelegate {

	func noteEditViewController(
		controller: NoteEditViewController,
		didTapDeleteNoteShortCutWithNoteObjectID noteObjectID: NSManagedObjectID) {
			guard let note = managedObjectContext.objectWithID(noteObjectID)
				as? Note else {
					fatalError()
			}
			managedObjectContext.deleteObject(note)
			managedObjectContext.performSaveOrRollback()
	}

}
