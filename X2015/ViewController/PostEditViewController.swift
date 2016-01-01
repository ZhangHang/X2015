//
//  PostEditViewController.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit

class PostEditViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var post: Post!
    var keyboardNotificationObserver: KeyboardNotificationObserver!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.keyboardNotificationObserver = KeyboardNotificationObserver(viewControllerView: self.view, keyboardOffsetChangeHandler: { [unowned self] (newKeyboardOffset) -> Void in
            var newContentInsect = self.textView.contentInset
            newContentInsect.bottom = newKeyboardOffset
            self.textView.contentInset = newContentInsect
        })
        
        self.title = post.title
        self.textView.text = post.content
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardNotificationObserver.startMonitor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardNotificationObserver.stopMonitor()
    }
    
}
