//
//  Note.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import CoreData

@objc(Note)
public final class Note: ManagedObject {

    @NSManaged public private(set) var content: String?
    @NSManaged public private(set) var createdAt: NSDate?

}

extension Note: ManagedObjectType {

    public override func awakeFromInsert() {
        self.createdAt = NSDate()
        super.awakeFromInsert()
    }

    public static var entityName: String {
        return "Note"
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
    }

}

extension Note {

    var title: String? {
        return content?.lineWithContent(0)
    }

    var preview: String? {
        return content?.lineWithContent(1)
    }

}
