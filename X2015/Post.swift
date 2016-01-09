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
    
    var _title: String?
    var title: String? {
        if let content = content {
            content.enumerateLines({ [unowned self](line, stop) -> () in
                self._title = line
                stop = true
                })
        }
        return _title
    }
    
    @NSManaged public private(set) var content: String?
    @NSManaged public private(set) var createdAt: NSDate?
    
}

extension Post: ManagedObjectType {
    
    public override func awakeFromInsert() {
        self.createdAt = NSDate()
        super.awakeFromInsert()
    }
    
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
    
    public func update(content: String) {
        self.content = content
    }
    
}