//
//  Note.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import CoreData
import CoreSpotlight

@objc(Note)
public final class Note: NSManagedObject {

	@NSManaged public private(set) var identifier: String
	@NSManaged public private(set) var content: String?
	@NSManaged public private(set) var createdAt: NSDate

	var searchIndex: CSSearchableItem?

	static public var searchIndexEnabled = false
}

extension Note: ManagedObjectType {

	public static var entityName: String {
		return "Note"
	}

}

extension Note {

	public override func awakeFromInsert() {
		identifier = NSUUID().UUIDString
		createdAt = NSDate()
		super.awakeFromInsert()
	}

	public override func awakeFromFetch() {
		if Note.searchIndexEnabled {
			updateSearchIndex()
		}
		super.awakeFromFetch()
	}

	public override func prepareForDeletion() {
		if Note.searchIndexEnabled {
			deleteSearchIndex()
		}
		super.prepareForDeletion()
	}

	public static var defaultSortDescriptors: [NSSortDescriptor] {
		return [NSSortDescriptor(key: "createdAt", ascending: false)]
	}


	public static var defaultPredicate: NSPredicate {
		return NSPredicate(format: "%K == NULL", "")
	}

}

extension Note {

	public func update(content: String) {
		self.content = content
		if Note.searchIndexEnabled {
			updateSearchIndex()
		}
	}

	public func hasChange(newContent: String) -> Bool {
		return self.content != newContent
	}
}

extension Note {

	public var title: String? {
		return content?.lineWithContent(0)
	}

	public var preview: String? {
		return content?.lineWithContent(1)
	}

	public var body: String? {
		guard let preview = preview else {
			return nil
		}
		guard let range = content?.rangeOfString(preview) else {
			fatalError()
		}

		return content!.substringFromIndex(range.startIndex)
	}

}

extension Note {

	public static func fetchNote(identifier: String, managedObjectContext: NSManagedObjectContext) -> Note? {
		let fetchRequest = NSFetchRequest(entityName: Note.entityName)
		fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
		fetchRequest.fetchLimit = 1
		do {
			if let results = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Note]
				where results.count == 1 {
					return results.first
			}
		} catch let e {
			debugPrint("fetch with error \(e)")
		}

		return nil
	}
}
