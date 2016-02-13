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

final class NoteEditViewController: ThemeAdaptableViewController {

	struct Storyboard {

		static let identifier = "NoteEditViewController"

		static let SegueIdentifierCreate = "CreateNoteSegueIdentifier"
		static let SegueIdentifierCreateWithNoAnimation = "CreateNoteWithNoAnimationSegueIdentifier"
		static let SegueIdentifierEdit = "EditNoteSegueIdentifier"
		static let SegueIdentifierEditWithNoAnimation = "EditNoteWithNoAnimationSegueIdentifier"
		static let SegueIdentifierEmpty = "EmptyNoteSegueIdentifier"

	}

	enum Mode {

		case Create(NSManagedObjectID, NSManagedObjectContext)
		case Edit(NSManagedObjectID, NSManagedObjectContext)
		case Empty

	}

	var noteActionMode: Mode = .Empty {

		didSet {
			switch noteActionMode {
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
				configureInterface(noteActionMode)
			}

			updateTitleIfNeeded()
		}

	}

	weak var delegate: NoteEditViewControllerDelegate?

	@IBOutlet weak var textView: UITextView!
	private var emptyWelcomeView: EmptyNoteWelcomeView?
	var actionBarButton: UIBarButtonItem {
		return navigationItem.rightBarButtonItem!
	}

	var noteUpdater: NoteUpdater?
	private var keyboardNotificationObserver: KeyboardNotificationObserver!

	//MARK: Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		keyboardNotificationObserver = KeyboardNotificationObserver(
			viewControllerView: view,
			keyboardOffsetChangeHandler: { [unowned self] (newKeyboardOffset) -> Void in
				var newContentInsect = self.textView.contentInset
				newContentInsect.bottom = newKeyboardOffset
				self.textView.contentInset = newContentInsect
			})

		configureInterface(noteActionMode)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		keyboardNotificationObserver.startMonitor()

		switch noteActionMode {
		case .Create:
			textView.becomeFirstResponder()
		default:
			break
		}
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		keyboardNotificationObserver.stopMonitor()
	}

	// Preview action items.
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
			emptyWelcomeView?.configureTheme(theme)
		}

		if animated {
			UIView.animateWithDuration(themeTransitionDuration, animations: updateInterface)
		} else {
			updateInterface()
		}
	}

}

extension NoteEditViewController: UITextViewDelegate {

	func updateTitleIfNeeded() {
		if let updater = noteUpdater {
			let noteTitle =  updater.noteTitle
			if noteTitle != title {
				title = updater.noteTitle
			}
		} else {
			title = nil
		}
	}

	func updateActionButtonIfNeeded() {
		let isContentEmpty = textView.text.empty

		if actionBarButton.enabled != !isContentEmpty {
			actionBarButton.enabled = !isContentEmpty
		}
	}

	func textViewDidChange(textView: UITextView) {
		updateActionButtonIfNeeded()
		noteUpdater!.updateNote(textView.text)
	}


	//swiftlint:disable variable_name
	func textView(textView: UITextView,
		shouldInteractWithURL URL: NSURL,
		inRange characterRange: NSRange) -> Bool {
		return true
	}
	//swiftlint:enable variable_name

}

extension NoteEditViewController {

	private func configureInterface(mode: Mode) {
		switch noteActionMode {
		case .Empty:
			textView.hidden = true
			emptyWelcomeView = EmptyNoteWelcomeView.instantiateFromNib()
			guard let emptyView = emptyWelcomeView else {
				fatalError()
			}
			emptyView.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(emptyView)
			view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[welcomeView]-0-|",
				options: .DirectionLeadingToTrailing,
				metrics: nil,
				views: ["welcomeView": emptyView]))
			view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[welcomeView]-0-|",
				options: .DirectionLeadingToTrailing,
				metrics: nil,
				views: ["welcomeView": emptyView]))
			view.bringSubviewToFront(emptyView)
		case .Edit(_, _):
			emptyWelcomeView?.removeFromSuperview()
			textView.hidden = false
			textView.text = noteUpdater!.noteContent
			navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
			navigationItem.leftItemsSupplementBackButton = true
		case .Create(_):
			emptyWelcomeView?.removeFromSuperview()
			textView.hidden = false
			textView.text = ""
			navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
			navigationItem.leftItemsSupplementBackButton = true
		}

		updateActionButtonIfNeeded()
	}

}
