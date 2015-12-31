//
//  Post.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import CoreData

public final class Post: NSManagedObject {
    
    @NSManaged public private(set) var title: String?
    @NSManaged public private(set) var content: String?
    @NSManaged public private(set) var createdAt: NSDate?
    @NSManaged public private(set) var updatedAt: NSDate?
    
}

extension Post {
    
    
    
}