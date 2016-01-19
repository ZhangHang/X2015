//
//  NoteEditViewController.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

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

    var managedObjectContext: NSManagedObjectContext!

    @IBOutlet private weak var textView: UITextView!

    private weak var note: Note?
    private var keyboardNotificationObserver: KeyboardNotificationObserver!

    func setup(managedObjectContext: NSManagedObjectContext!, exsitingNote: Note? = nil) {
		note = exsitingNote
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

        title = note?.title
        textView.text = note?.content
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardNotificationObserver.startMonitor()

        if note == nil {
            textView.becomeFirstResponder()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardNotificationObserver.stopMonitor()

        if !hasContent && self.note == nil {
			// TODO: Display an alert
            return
        }

        managedObjectContext.performChanges { [unowned self] () -> () in
            let note = self.note ?? self.managedObjectContext.insertObject()
            note.update(self.textView.text)
        }
    }

}

extension NoteEditViewController {

    var noteContent: String {
        return textView.text
    }

    var hasContent: Bool {
        return noteContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
    }

    var noteTitle: String? {
        return noteContent.lineWithContent(0)
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
