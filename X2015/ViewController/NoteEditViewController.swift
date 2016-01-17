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
    
    func setup(exsitingNote: Note!, managedObjectContext: NSManagedObjectContext!){
        self.note = exsitingNote
        self.managedObjectContext = managedObjectContext
    }
    
    func setup(managedObjectContext: NSManagedObjectContext!){
        self.managedObjectContext = managedObjectContext
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.keyboardNotificationObserver = KeyboardNotificationObserver(
            viewControllerView: self.view,
            keyboardOffsetChangeHandler: { [unowned self] (newKeyboardOffset) -> Void in
                var newContentInsect = self.textView.contentInset
                newContentInsect.bottom = newKeyboardOffset
                self.textView.contentInset = newContentInsect
            })
        
        self.title = note?.title
        self.textView.text = note?.content
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardNotificationObserver.startMonitor()
        
        if self.note == nil {
            self.textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardNotificationObserver.stopMonitor()
        
        if !self.hasContent {
            return
        }
        
        self.managedObjectContext.performChanges { [unowned self] () -> () in
            let note = self.note ?? self.managedObjectContext.insertObject()
            note.update(self.textView.text)
        }
    }
    
}

extension NoteEditViewController {
    
    var NoteContent: String {
        return self.textView.text
    }
    
    var hasContent: Bool {
        return self.NoteContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
    }
    
    var NoteTitle: String? {
        return self.NoteContent.lineWithContent(0)
    }
    
}

extension NoteEditViewController: UITextViewDelegate {
    
    func updateViewControllerTitleIfNesscarry() {
        if self.NoteTitle != self.title {
            self.title = self.NoteTitle
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        self.updateViewControllerTitleIfNesscarry()
    }
    
}