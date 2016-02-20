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
	@IBOutlet weak var textView: RichFormatTextView!

	/// background view
	var emptyWelcomeView: EmptyNoteWelcomeView?

	/// Manage note entity
	var noteManager: NoteManager?

	/// Curren note editing mode
	var editingMode: EditingMode = .Empty {
		didSet {
			switch editingMode {
			case let .Create(managedObjectID, managedObjectContext):
				noteManager = NoteManager(noteObjectID: managedObjectID,
					managedObjectContext: managedObjectContext)
				break
			case let .Edit(managedObjectID, managedObjectContext):
				noteManager = NoteManager(noteObjectID: managedObjectID,
					managedObjectContext: managedObjectContext)
				break
			case .Empty:
				break
			}
			// alaways update the title of controller after an edting mode has been set
			updateTitleIfNeeded()

			if isViewLoaded() {
				configureInterface(editingMode)
				updateInterface()
			}
			noteManager?.emptyStatusDidChange = { [unowned self] in
				self.updateActionButtonIfNeeded()
			}
			noteManager?.titleDidChange = { [unowned self] in
				self.updateTitleIfNeeded()
			}
		}
	}

	/// The delegate
	weak var delegate: NoteEditViewControllerDelegate?

	/// Bar buttons
	@IBOutlet weak var actionButton: UIBarButtonItem!
	@IBOutlet weak var playButton: UIBarButtonItem!

	/// NoteReaderController
	var noteReaderController: NoteReaderController?

	/// Preview action items.
	lazy var previewActions: [UIPreviewActionItem] = {
		let deleteAction = UIPreviewAction(
			title: NSLocalizedString("Delete", comment: ""),
			style: .Destructive,
			handler: { [unowned self] (_, _) -> Void in
				self.delegate?.noteEditViewController(self,
					didTapDeleteNoteShortCutWithNoteObjectID: self.noteManager!.noteObjectID)
			})
		return [deleteAction]
	}()

	// MARK: Preview actions
	override func previewActionItems() -> [UIPreviewActionItem] {
		return previewActions
	}

	// MARK : Theme

	override func willUpdateThemeInterface(theme: Theme) {
		noteReaderController?.view.hidden = true
		noteReaderController?.configureTheme(theme)
	}

	override func didUpdateThemeInterface(theme: Theme) {
		noteReaderController?.view.hidden = false
	}

	override func updateThemeInterface(theme: Theme, animated: Bool) {
		super.updateThemeInterface(theme, animated: animated)
		func updateInterface() {
			textView.configureTheme(theme)
			emptyWelcomeView?.configureTheme(theme)
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
		updateInterface()
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidAppear(animated)
		destroyNoteReaderControllerIfNeeded()
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
