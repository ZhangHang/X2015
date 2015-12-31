//
//  MainViewController.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, ManagedObjectContextSettable{
    
    var simplePost: Post?
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(managedContext)
    }
    
}