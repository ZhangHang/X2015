//
//  ManagedObjectContextBridge.swift
//  X2015
//
//  Created by Hang Zhang on 2/1/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation
import CoreData
//swiftlint:disable variable_name
private let X2015GroupIdentifier = "group.x2015container"
private let ManagedObjectContextBridgeDataChangeKey = "ManagedObjectContextBridgeDataChangeKey"

//swiftlint:disable variable_name_max_length
//swiftlint:disable line_length
private let ManagedObjectContextBridgeDataChangedNotificationName = "ManagedObjectContextBridgeDataChangedNotificationName"
private let ManagedObjectContextBridgeDataChangedDarwinNotificationName = "ManagedObjectContextBridgeDataChangedDarwinNotificationName"
//swiftlint:enable line_length
//swiftlint:enable variable_name_max_length
//swiftlint:enable variable_name

public class ManagedObjectContextBridge {

	public var managedObjectContext: NSManagedObjectContext!

	/**
	Policy

	- Send:    Send out ManagedObjectContextDidChange notification to other process
	- Receive: Receive ManagedObjectContextDidChange from other process
	*/
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

extension ManagedObjectContextBridge {

	// Create a single managedObjectContext
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
				name: ManagedObjectContextBridgeDataChangedNotificationName,
				object: nil)

			CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
				nil, { (center, observer, name, object, userInfo) in
					debugPrint("received notification: \(name)")
					NSNotificationCenter
						.defaultCenter()
						.postNotificationName(ManagedObjectContextBridgeDataChangedNotificationName,
							object: nil)
				},
				ManagedObjectContextBridgeDataChangedDarwinNotificationName,
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
		if let data = userDefaults!.objectForKey(ManagedObjectContextBridgeDataChangeKey) as? NSData,
			let existingNotificationDatas = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [AnyObject] {
				notificationDatas.appendContentsOf(existingNotificationDatas)
		}

		notificationDatas.append(notificationData)
		let archivedData: NSData = NSKeyedArchiver.archivedDataWithRootObject(notificationDatas)

		userDefaults!.setObject(archivedData, forKey: ManagedObjectContextBridgeDataChangeKey)
		userDefaults!.synchronize()

		postCFNotification(ManagedObjectContextBridgeDataChangedDarwinNotificationName)
	}

}

extension ManagedObjectContextBridge {

	private func postCFNotification(notificationName: String) {
		debugPrint("post cf notification with name \(notificationName)")
		let center = CFNotificationCenterGetDarwinNotifyCenter()
		CFNotificationCenterPostNotification(center, notificationName, nil, nil, true)
	}

}

extension NSManagedObjectContext {

	public func mergeChangesFromUserDefaults() {
		let userDefaults = NSUserDefaults(suiteName: X2015GroupIdentifier)

		defer {
			userDefaults!.removeObjectForKey(ManagedObjectContextBridgeDataChangeKey)
			userDefaults!.synchronize()
		}

		guard let data = userDefaults!.objectForKey(ManagedObjectContextBridgeDataChangeKey) as? NSData else {
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
