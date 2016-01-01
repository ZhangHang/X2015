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
    
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var updatedAt: NSDate?
    
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