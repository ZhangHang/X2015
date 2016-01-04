//
//  AppDelegate.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let managedObjectContext: NSManagedObjectContext = AppDelegate.createMainContext()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.fillFakeData()
        guard let nc = window?.rootViewController as? UINavigationController,
            vc = nc.childViewControllers.first as? ManagedObjectContextSettable else {
                fatalError("Wrong view controller type")
        }
        vc.managedObjectContext = self.managedObjectContext
        return true
    }
    
    
    // MARK: - Core Data stack
    
    private static let StoreURL = NSURL.documentsURL.URLByAppendingPathComponent("X2015.moody")
    
    static func createMainContext() -> NSManagedObjectContext {
        let bundles = [NSBundle(forClass: Post.self)]
        guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
            fatalError("model not found")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: StoreURL, options: nil)
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        return context
    }
    
    func fillFakeData() {
        if Post.fetchInContext(self.managedObjectContext).count > 0 {
            return
        }

        let titlePrefix = "Let There be "
        for i in 1...10 {
            let newPost = NSEntityDescription.insertNewObjectForEntityForName(Post.entityName, inManagedObjectContext: self.managedObjectContext) as! Post
            newPost.update("\(titlePrefix)\(i)", content: "\(NSDate())")
        }
        
        if !self.managedObjectContext.saveOrRollback() {
            fatalError("can't fill fake data")
        }
    }
    
}


protocol ManagedObjectContextSettable: class {
    
    var managedObjectContext: NSManagedObjectContext! { get set }
    
}