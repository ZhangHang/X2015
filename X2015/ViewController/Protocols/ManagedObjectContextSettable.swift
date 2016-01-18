//
//  ManagedObjectContextSettable.swift
//  X2015
//
//  Created by Hang Zhang on 1/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import CoreData

protocol ManagedObjectContextSettable: class {

    var managedObjectContext: NSManagedObjectContext! { get set }

}
