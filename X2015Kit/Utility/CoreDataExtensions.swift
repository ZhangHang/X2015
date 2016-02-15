//
//  CoreDataExtensions.swift
//  X2015
//
//  Created by Hang Zhang on 2/15/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import CoreData

public protocol ManagedObjectType: class {

	static var entityName: String { get }

}

extension NSManagedObjectContext {

	public func insertObject<A: NSManagedObject where A: ManagedObjectType>() -> A {
		guard
			let obj =
			NSEntityDescription.insertNewObjectForEntityForName(
				A.entityName,
				inManagedObjectContext: self) as? A else {
					fatalError("Wrong object type")
		}
		return obj
	}

	public func saveOrRollback() -> Bool {
		do {
			try save()
			return true
		} catch {
			rollback()
			return false
		}
	}

	public func performSaveOrRollback() {
		performBlock {
			self.saveOrRollback()
		}
	}

	public func performChanges(block: () -> ()) {
		performBlock {
			block()
			self.saveOrRollback()
		}
	}

}
