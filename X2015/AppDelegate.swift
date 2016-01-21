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
final class AppDelegate: UIResponder, UIApplicationDelegate {

	enum ShortcutIdentifier: String {
		case NewNote

		// MARK: Initializers

		init?(fullType: String) {
			guard let last = fullType.componentsSeparatedByString(".").last else { return nil }

			self.init(rawValue: last)
		}

		// MARK: Properties

		var type: String {
			return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
		}
	}

	var window: UIWindow?
	var launchedShortcutItem: UIApplicationShortcutItem?
	let managedObjectContext: NSManagedObjectContext = AppDelegate.createMainContext()

	private var rootViewControllerCache: UIViewController?
	private var lockViewController = LockViewController.instanceFromStoryboard()

	func application(
		application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [NSObject: AnyObject]?) -> Bool {

			// configure interface
			configureInterface()

			// pass managedObjectContext
			guard let vc = window!.rootViewController as? ManagedObjectContextSettable else {
				fatalError("Wrong view controller type")
			}
			vc.managedObjectContext = managedObjectContext

			// handle application shortcut
			var shouldPerformAdditionalDelegateHandling = true
			if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey]
				as? UIApplicationShortcutItem {
					launchedShortcutItem = shortcutItem
					shouldPerformAdditionalDelegateHandling = false
			}

			// Touch ID
			hideWindowIfTouchIDUnlockEnabled()
			presentTouchIDUnlockRequestIfEnabled()

			return shouldPerformAdditionalDelegateHandling
	}

	func applicationDidBecomeActive(application: UIApplication) {
		guard let shortcut = launchedShortcutItem else { return }
		handleShortcut(shortcut)
		launchedShortcutItem = nil
	}

	func application(
		application: UIApplication,
		performActionForShortcutItem shortcutItem: UIApplicationShortcutItem,
		completionHandler: (Bool) -> Void) {
			completionHandler(handleShortcut(shortcutItem))
	}

	func applicationWillEnterForeground(application: UIApplication) {
		presentTouchIDUnlockRequestIfEnabled()
	}

	func applicationDidEnterBackground(application: UIApplication) {
		hideWindowIfTouchIDUnlockEnabled()
	}

	// MARK: - Core Data stack

	private static let StoreURL = NSURL.documentsURL.URLByAppendingPathComponent("X2015.moody")

	static func createMainContext() -> NSManagedObjectContext {
		let bundles = [NSBundle(forClass: Note.self)]
		guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
			fatalError("model not found")
		}
		let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
		do {
			try psc.addPersistentStoreWithType(
				NSSQLiteStoreType, configuration: nil,
				URL: StoreURL,
				options: nil)
			let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
			context.persistentStoreCoordinator = psc
			return context
		} catch {
			fatalError()
		}
	}

}

extension AppDelegate {

	private func configureInterface() {
		window!.tintColor = UIColor.x2015_BlueColor()
		window!.backgroundColor = UIColor.whiteColor()

		UIHelper.setupNavigationBarStyle(
			window!.tintColor,
			backgroundColor: UIColor.whiteColor(),
			barStyle: .Black)
	}

	private func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
		guard let shortcutIdentifier = ShortcutIdentifier(fullType: shortcutItem.type) else { return false }

		switch shortcutIdentifier {
		case .NewNote:
			guard let vc = window!.rootViewController as? RootTabBarController else {
				fatalError("Wrong view controller type")
			}
			vc.handleNewNoteShortcut()

			return true
		}
	}
}

extension AppDelegate {

	private func hideWindowIfTouchIDUnlockEnabled() {
		if Settings().unlockByTouchID && TouchIDHelper.hasTouchID {
			rootViewControllerCache = window!.rootViewController
			window!.rootViewController = lockViewController
		}
	}

	private func presentTouchIDUnlockRequestIfEnabled() {
		if Settings().unlockByTouchID && TouchIDHelper.hasTouchID {
			TouchIDHelper.auth(
				NSLocalizedString("Use Touch ID to Unlock", comment: ""),
				successHandler: { [unowned self] () -> Void in
					self.window!.rootViewController = self.rootViewControllerCache
					self.rootViewControllerCache = nil
				}) { (errorMessage) -> Void in
			}
		}
	}

}
