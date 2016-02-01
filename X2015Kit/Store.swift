//
//  Store.swift
//  X2015
//
//  Created by Hang Zhang on 2/1/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation
import CoreData

public struct StoreHelper {

	public static func createMainContext() -> NSManagedObjectContext {
		let storeURL: NSURL = {
			let url = NSFileManager
				.defaultManager()
				.containerURLForSecurityApplicationGroupIdentifier("group.x2015container")!
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
			return context
		} catch {
			fatalError()
		}
	}

}
