//
//  Post.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import CoreData

@objc(Post)
public final class Post: ManagedObject {
    
    @NSManaged public private(set) var title: String?
    @NSManaged public private(set) var content: String?
    @NSManaged public private(set) var createdAt: NSDate?
    @NSManaged public private(set) var updatedAt: NSDate?
    
}

extension Post: ManagedObjectType {
    
    public static var entityName: String {
        return "Post"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "createdAt", ascending: false)]
    }
    
    
    public static var defaultPredicate: NSPredicate {
        return NSPredicate(format: "%K == NULL", "")
    }
    
}

extension Post {
    
    public func update(title: String, content: String) {
        self.title = title
        self.content = content
        self.updatedAt = NSDate()
        self.createdAt = NSDate()
    }
    
    public func updateContent(newContent: String) {
        self.content = newContent
        self.updatedAt = NSDate()
    }
    
}