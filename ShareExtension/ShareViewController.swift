//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Hang Zhang on 2/1/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import Social
import X2015Kit

final class ShareViewController: SLComposeServiceViewController {

	var managedObjectContext: NSManagedObjectContext! {
		return managedObjectContextBridge.managedObjectContext
	}
	let managedObjectContextBridge = ManagedObjectContextBridge(policies: [.Send])

	override func presentationAnimationDidFinish() {
		super.presentationAnimationDidFinish()
	}

    override func isContentValid() -> Bool {
		return contentText.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
    }

    override func didSelectPost() {
		managedObjectContext.performChanges { [unowned self] () -> () in
			let newNote: Note = self.managedObjectContext.insertObject()
			newNote.update(self.contentText)
			self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
		}
    }

    override func configurationItems() -> [AnyObject]! {
        return []
    }

}
