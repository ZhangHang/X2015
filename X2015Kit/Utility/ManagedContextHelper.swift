//
//  ManagedContextHelper.swift
//  X2015
//
//  Created by Hang Zhang on 2/1/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation
import CoreData
//swiftlint:disable variable_name
public let X2015GroupIdentifier = "group.x2015container"
public let X2015DataChangedKey = "X2015DataChangedKey"
//swiftlint:enable variable_name

public class ManagedContextHelper {

	public var managedObjectContext: NSManagedObjectContext!

	public init() {
		managedObjectContext = createMainContext()
	}

	private func createMainContext(observeRemoteChanges: Bool = true) -> NSManagedObjectContext {
		let storeURL: NSURL = {
			let url = NSFileManager
				.defaultManager()
				.containerURLForSecurityApplicationGroupIdentifier(X2015GroupIdentifier)!
			return url.URLByAppendingPathComponent("db.sqlit")
		}()

		let bundles = [NSBundle(forClass: Note.self)]
		guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
			fatalError("model not found")
		}
		let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
		do {
			try psc.addPersistentStoreWithType(
				NSSQLiteStoreType, configuration: nil,
				URL: storeURL,
				options: nil)
			let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
			context.persistentStoreCoordinator = psc

			if observeRemoteChanges {
				NSNotificationCenter
					.defaultCenter()
					.addObserver(self,
						selector: "handleContextDidSave:",
						name: NSManagedObjectContextDidSaveNotification,
						object: nil)
			}

			return context
		} catch {
			fatalError()
		}
	}

	// From: https://www.innoq.com/en/blog/ios-writing-core-data-in-today-extension/
	@objc
	private func handleContextDidSave(notification: NSNotification) {
		guard let userInfo = notification.userInfo else {
			return
		}

		let userDefaults = NSUserDefaults(suiteName: X2015GroupIdentifier)
		var notificationData = [NSObject : AnyObject]()

		for (key, value) in userInfo {
			guard let value = value as? NSSet else {
				continue
			}

			var uriRepresentations = [AnyObject]()
			for element in value {
				guard let managedObject = element as? NSManagedObject else {
					continue
				}

				uriRepresentations.append(managedObject.objectID.URIRepresentation())
			}

			notificationData[key] = uriRepresentations
		}


		var notificationDatas = [AnyObject]()
		if let data = userDefaults!.objectForKey(X2015DataChangedKey) as? NSData,
			let existingNotificationDatas = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [AnyObject] {
				notificationDatas.appendContentsOf(existingNotificationDatas)
		}

		notificationDatas.append(notificationData)
		let archivedData: NSData = NSKeyedArchiver.archivedDataWithRootObject(notificationDatas)

		userDefaults!.setObject(archivedData, forKey: X2015DataChangedKey)
		userDefaults!.synchronize()
	}



}

extension NSManagedObjectContext {

	public func mergeChangesFromUserDefaults() {
		let userDefaults = NSUserDefaults(suiteName: X2015GroupIdentifier)

		defer {
			userDefaults!.removeObjectForKey(X2015DataChangedKey)
			userDefaults!.synchronize()
		}

		guard let data = userDefaults!.objectForKey(X2015DataChangedKey) as? NSData else {
			return
		}

		guard let notificationsArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [AnyObject] else {
			return
		}

		performBlock {
			for notificationData in notificationsArray {
				guard let notificationData = notificationData as? [NSObject : AnyObject] else {
					continue
				}

				NSManagedObjectContext.mergeChangesFromRemoteContextSave(notificationData, intoContexts: [self])
			}
		}
	}

}
