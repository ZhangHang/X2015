//
//  NoteEditViewController.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

protocol NoteEditViewControllerDelegate: class {

	func noteEditViewController(
		controller: NoteEditViewController,
		didTapDeleteNoteShortCutWithNoteObjectID noteObjectID: NSManagedObjectID)

}

final class NoteEditViewController: UIViewController, ManagedObjectContextSettable {

	static let storyboardID = "NoteEditViewController"

	enum SegueIdentifier {

		case Create, Edit

		func identifier() -> String {
			switch self {
			case .Create:
				return "CreateNoteSegueIdentifier"
			case .Edit:
				return "EditNoteSegueIdentifier"
			}
		}

	}

	enum NoteAction: String {

		case Create
		case Update
		case Delete
		case Unmodified

		init?(newContent: String, exsitingNote: Note?) {
			let hasContent = newContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0

			var rawValue = "Unmodified"

			if !hasContent && exsitingNote != nil {
				rawValue = "Delete"
			}

			if hasContent && exsitingNote == nil {
				rawValue = "Create"
			}

			if hasContent && exsitingNote != nil {
				if exsitingNote!.hasChange(newContent) {
					rawValue = "Update"
				}
			}

			self.init(rawValue: rawValue)
		}

	}

	weak var delegate: NoteEditViewControllerDelegate?

	private var noteObjectID: NSManagedObjectID?

	var managedObjectContext: NSManagedObjectContext!

	@IBOutlet private weak var textView: UITextView!

	private var keyboardNotificationObserver: KeyboardNotificationObserver!

	func setup(managedObjectContext: NSManagedObjectContext!, exsitingNoteID: NSManagedObjectID? = nil) {
		if let exsitingNoteID = exsitingNoteID {
			guard let _ = managedObjectContext.objectWithID(exsitingNoteID) as? Note else {
				fatalError("Can't fetch note with objectID \(exsitingNoteID)")
			}
			noteObjectID = exsitingNoteID
		}
		self.managedObjectContext = managedObjectContext
	}


	override func viewDidLoad() {
		super.viewDidLoad()

		keyboardNotificationObserver = KeyboardNotificationObserver(
			viewControllerView: view,
			keyboardOffsetChangeHandler: { [unowned self] (newKeyboardOffset) -> Void in
				var newContentInsect = self.textView.contentInset
				newContentInsect.bottom = newKeyboardOffset
				self.textView.contentInset = newContentInsect
			})

		let note = self.fetchNoteFromContext()
		title = note?.title
		textView.text = note?.content
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		keyboardNotificationObserver.startMonitor()

		if noteObjectID == nil {
			textView.becomeFirstResponder()
		}
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		keyboardNotificationObserver.stopMonitor()

		guard let action = NoteAction(
			newContent: textView.text,
			exsitingNote: self.fetchNoteFromContext()) else {
				fatalError()
		}

		processNote(action)
	}


	// Preview action items.
	lazy var previewActions: [UIPreviewActionItem] = {
		let deleteAction = UIPreviewAction(
			title: NSLocalizedString("Delete", comment: ""),
			style: .Destructive,
			handler: { [unowned self] (_, _) -> Void in
				// todo: delete a note after action handler called
				//				self.processNote(.Delete)
				self.delegate?.noteEditViewController(self, didTapDeleteNoteShortCutWithNoteObjectID: self.noteObjectID!)
			})
		return [deleteAction]
	}()

	// MARK: Preview actions
	override func previewActionItems() -> [UIPreviewActionItem] {
		return previewActions
	}
}

extension NoteEditViewController {

	var noteContent: String {
		return textView.text
	}

	var noteTitle: String? {
		return noteContent.lineWithContent(0)
	}

	func fetchNoteFromContext() -> Note? {
		if let exsitingNoteID = noteObjectID {
			guard let note = managedObjectContext.objectWithID(exsitingNoteID) as? Note else {
				fatalError("Can't fetch note with objectID \(exsitingNoteID)")
			}
			return note
		}
		return nil
	}
}

extension NoteEditViewController: UITextViewDelegate {

	func updateViewControllerTitleIfNesscarry() {
		if noteTitle != title {
			title = noteTitle
		}
	}

	func textViewDidChange(textView: UITextView) {
		updateViewControllerTitleIfNesscarry()
	}

}

extension NoteEditViewController {

	private func processNote(action: NoteAction) {
		switch action {
		case .Delete:
			managedObjectContext.performChanges({ [unowned self] () -> () in
				guard let note = self.fetchNoteFromContext() else { fatalError() }
				self.managedObjectContext.deleteObject(note)
				})
			break
		case .Create, .Update:
			managedObjectContext.performChanges({ [unowned self] () -> () in
				let note = self.fetchNoteFromContext() ?? self.managedObjectContext.insertObject()
				note.update(self.textView.text)
				})
			break
		default:
			break
		}
	}

}
