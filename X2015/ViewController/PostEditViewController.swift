//
//  PostEditViewController.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

final class PostEditViewController: UIViewController, ManagedObjectContextSettable {
    
    enum SegueIdentifier {
        case Create, Edit
        
        func identifier() -> String {
            switch self {
            case .Create:
                return "CreatePostSegueIdentifier"
            case .Edit:
                return "EditPostSegueIdentifier"
            }
        }
        
    }
    
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet private weak var textView: UITextView!
    
    private weak var post: Post?
    private var keyboardNotificationObserver: KeyboardNotificationObserver!
    
    func setup(exsitingPost: Post!, managedObjectContext: NSManagedObjectContext!){
        self.post = exsitingPost
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
        
        self.title = post?.title
        self.textView.text = post?.content
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardNotificationObserver.startMonitor()
        
        if self.post == nil {
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
            let post = self.post ?? self.managedObjectContext.insertObject()
            post.update(self.textView.text)
        }
    }
    
}

extension PostEditViewController {
    
    var postContent: String {
        return self.textView.text
    }
    
    var hasContent: Bool {
        return self.postContent.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
    }
    
    var postTitle: String? {
        return self.postContent.lineWithContent(0)
    }
    
}

extension PostEditViewController: UITextViewDelegate {
    
    func updateViewControllerTitleIfNesscarry() {
        if self.postTitle != self.title {
            self.title = self.postTitle
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        self.updateViewControllerTitleIfNesscarry()
    }
    
}