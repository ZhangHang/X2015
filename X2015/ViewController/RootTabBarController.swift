//
//  RootTabBarController.swift
//  X2015
//
//  Created by Hang Zhang on 1/17/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

class RootTabBarController: UITabBarController, ManagedObjectContextSettable {

    var managedObjectContext: NSManagedObjectContext!
    
    var noteTimelineViewController: NoteTimelineTableViewController {
        guard let nc = self.childViewControllers.first as? UINavigationController,
            let vc = nc.childViewControllers.first as? NoteTimelineTableViewController else {
        fatalError("Wrong view controller type found")
        }
        
        return vc
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noteTimelineViewController.managedObjectContext = self.managedObjectContext
        // Do any additional setup after loading the view.
    }

}
