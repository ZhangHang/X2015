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
import CoreData

final class ShareViewController: SLComposeServiceViewController {

	let managedObjectContext: NSManagedObjectContext = StoreHelper.createMainContext()

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
