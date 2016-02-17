//
//  NoteEditViewController.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData
import Marklight

protocol NoteEditViewControllerDelegate: class {

	func noteEditViewController(
		controller: NoteEditViewController,
		didTapDeleteNoteShortCutWithNoteObjectID noteObjectID: NSManagedObjectID)

}

final class NoteEditViewController: ThemeAdaptableViewController {

	struct SegueIdentifier {
		static let Create = "CreateNoteSegueIdentifier"
		static let CreateWithNoAnimation = "CreateNoteWithNoAnimationSegueIdentifier"
		static let Edit = "EditNoteSegueIdentifier"
		static let EditWithNoAnimation = "EditNoteWithNoAnimationSegueIdentifier"
		static let Empty = "EmptyNoteSegueIdentifier"
	}

	/**
	Editing Mode

	- Create: Create new note
	- Edit:   Edit existing note
	- Empty:  No note to edit or display
	*/
	enum EditingMode {
		case Create(NSManagedObjectID, NSManagedObjectContext)
		case Edit(NSManagedObjectID, NSManagedObjectContext)
		case Empty
	}

	// Mark: Editor
	@IBOutlet weak var textView: UITextView!

	/// background view
	var emptyWelcomeView: EmptyNoteWelcomeView?

	/// Manage note entity
	var noteUpdater: NoteUpdater?

	/// Curren note editing mode
	var editingMode: EditingMode = .Empty {
		didSet {
			switch editingMode {
			case let .Create(managedObjectID, managedObjectContext):
				noteUpdater = NoteUpdater(noteObjectID: managedObjectID,
					managedObjectContext: managedObjectContext)
				break
			case let .Edit(managedObjectID, managedObjectContext):
				noteUpdater = NoteUpdater(noteObjectID: managedObjectID,
					managedObjectContext: managedObjectContext)
				break
			case .Empty:
				break
			}
			if isViewLoaded() {
				configureInterface(editingMode)
			}

			updateTitleIfNeeded()
		}
	}

	/// Provides markdown render
	let markdownTextStorage = MarklightTextStorage()

	/// Handle markdown shortcuts
	var markdownShortcutHandler: MarkdownShortcutHandler?

	/// Set to true if `markdownShortcutHandler` is processing
	var markdownShortcutHandlerIsEditing = false


	/// The delegate
	weak var delegate: NoteEditViewControllerDelegate?

	/// Action button
	var actionBarButton: UIBarButtonItem {
		return navigationItem.rightBarButtonItem!
	}

	/// Preview action items.
	lazy var previewActions: [UIPreviewActionItem] = {
		let deleteAction = UIPreviewAction(
			title: NSLocalizedString("Delete", comment: ""),
			style: .Destructive,
			handler: { [unowned self] (_, _) -> Void in
				self.delegate?.noteEditViewController(self,
					didTapDeleteNoteShortCutWithNoteObjectID: self.noteUpdater!.noteObjectID)
			})
		return [deleteAction]
	}()

	// MARK: Preview actions
	override func previewActionItems() -> [UIPreviewActionItem] {
		return previewActions
	}

	// MARK : Theme
	override func updateThemeInterface(theme: Theme, animated: Bool) {
		super.updateThemeInterface(theme, animated: animated)
		func updateInterface() {
			textView.configureTheme(theme)
			guard let accessorView = textView.inputAccessoryView as? MarkdownInputAccessoryView else {
				fatalError()
			}
			accessorView.configureTheme(theme)
			emptyWelcomeView?.configureTheme(theme)
			markdownTextStorage.configureTheme(theme)
			refreshTextView_WORKAROUND()
		}

		if animated {
			UIView.animateWithDuration(themeTransitionDuration, animations: updateInterface)
		} else {
			updateInterface()
		}
	}

}

// MARK: Life cycle
extension NoteEditViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		configureEditor()
		registerForKeyboardEvent()
		configureInterface(editingMode)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnSwipe = false
		navigationController?.hidesBarsOnTap = true
		navigationController?.hidesBarsWhenKeyboardAppears = true

		switch editingMode {
		case .Create:
			textView.becomeFirstResponder()
		default:
			break
		}
	}

}

extension NoteEditViewController: SotyboardCreatable {

	static var storyboardName: String {
		return "Main"
	}

	static var viewControllerIdentifier: String {
		return "NoteEditViewController"
	}

}
