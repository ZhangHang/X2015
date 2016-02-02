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
private let X2015GroupIdentifier = "group.x2015container"
private let X2015DataChangedKey = "X2015DataChangedKey"

public let X2015DataChangedNotificationName = "X2015DataChangedNotificationName"
public let X2015DataChangeDarwindNotificationName = "X2015DataChangeDarwindNotificationName"
//swiftlint:enable variable_name

public class ManagedContextHelper {

	public var managedObjectContext: NSManagedObjectContext!

	public enum Policy {
		case Send
		case Receive
	}

	public required init(policies: [Policy]) {
		managedObjectContext = createMainContext(policies)
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

}

extension ManagedContextHelper {

	func createMainContext(
		policies: [Policy]) -> NSManagedObjectContext {
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
				handleOptions(policies, context: context)
				return context
			} catch {
				fatalError()
			}
	}

	private func handleOptions(policies: [Policy], context: NSManagedObjectContext) {
		if policies.contains(.Send) {
			NSNotificationCenter.defaultCenter().addObserver(self,
				selector: "handleContextDidSave:",
				name: NSManagedObjectContextDidSaveNotification,
				object: nil)
		}

		if policies.contains(.Receive) {
			NSNotificationCenter.defaultCenter().addObserver(self,
				selector: "handleCFDidSaveContext",
				name: X2015DataChangedNotificationName,
				object: nil)

			CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
				nil, { (center, observer, name, object, userInfo) in
					debugPrint("received notification: \(name)")
					NSNotificationCenter
						.defaultCenter()
						.postNotificationName(X2015DataChangedNotificationName,
							object: nil)
				},
				X2015DataChangeDarwindNotificationName,
				nil,
				.DeliverImmediately)
		}
	}

	@objc
	private func handleCFDidSaveContext() {
		managedObjectContext.mergeChangesFromUserDefaults()
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

		postCFNotification(X2015DataChangedNotificationName)
	}

}

extension ManagedContextHelper {

	private func postCFNotification(notificationName: String) {
		let center = CFNotificationCenterGetDarwinNotifyCenter()
		CFNotificationCenterPostNotification(center, X2015DataChangedNotificationName, nil, nil, true)
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
