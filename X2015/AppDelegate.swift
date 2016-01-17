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
        self.configureInterface()
        guard let tc = window?.rootViewController as? ManagedObjectContextSettable else {
                fatalError("Wrong view controller type")
        }
        tc.managedObjectContext = self.managedObjectContext
        return true
    }
    
    
    // MARK: - Core Data stack
    
    private static let StoreURL = NSURL.documentsURL.URLByAppendingPathComponent("X2015.moody")
    
    static func createMainContext() -> NSManagedObjectContext {
        let bundles = [NSBundle(forClass: Note.self)]
        guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
            fatalError("model not found")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: StoreURL, options: nil)
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        return context
    }
    
}

extension AppDelegate {
    
    private func configureInterface() {
        window!.tintColor = UIColor.x2015_BlueColor()
        
        UIHelper.setupNavigationBarStyle(window!.tintColor, backgroundColor: UIColor.whiteColor(), barStyle: .Black)
    }
    
}