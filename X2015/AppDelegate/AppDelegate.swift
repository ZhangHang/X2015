//
//  AppDelegate.swift
//  X2015
//
//  Created by Hang Zhang on 12/31/15.
//  Copyright © 2015 Zhang Hang. All rights reserved.
//

import UIKit
import CoreSpotlight
import X2015Kit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	// MARK: Shortcuts
	enum ShortcutIdentifier: String {
		case NewNote

		init?(fullType: String) {
			guard let last = fullType.componentsSeparatedByString(".").last else { return nil }

			self.init(rawValue: last)
		}

		var type: String {
			return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
		}
	}
	var launchedShortcutItem: UIApplicationShortcutItem?

	// MARK: Core Data
	var managedObjectContext: NSManagedObjectContext! {
		return managedObjectContextBridge.managedObjectContext
	}
	let managedObjectContextBridge = ManagedObjectContextBridge(policies: [.Send, .Receive])

	// MARK: Interface
	var window: UIWindow?
	var rootViewControllerCache: UISplitViewController?
	var lockViewController: LockViewController?

	// MARK: UIApplicationDelegate
	func application(
		application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [NSObject: AnyObject]?) -> Bool {

			// Configure interface
			configureInterface()

			// Pass managedObjectContext
			setupControllers()

			// Touch ID lock screen
			rootViewControllerCache = window!.rootViewController as? UISplitViewController
			setupLockViewController()
			bringUpLockViewControllerIfNeeded()

			// Handle application shortcut
			var shouldPerformAdditionalDelegateHandling = true
			if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey]
				as? UIApplicationShortcutItem {
					launchedShortcutItem = shortcutItem
					shouldPerformAdditionalDelegateHandling = false
			}

			return shouldPerformAdditionalDelegateHandling
	}

	func applicationWillTerminate(application: UIApplication) {
		managedObjectContext.saveOrRollback()
	}

	func applicationDidBecomeActive(application: UIApplication) {
		guard let shortcut = launchedShortcutItem else { return }
		handleShortcut(shortcut)
		launchedShortcutItem = nil
	}

	func application(application: UIApplication,
		performActionForShortcutItem shortcutItem: UIApplicationShortcutItem,
		completionHandler: (Bool) -> Void) {
			completionHandler(handleShortcut(shortcutItem))
	}

	func applicationWillEnterForeground(application: UIApplication) {
		managedObjectContext.mergeChangesFromUserDefaults()
		bringUpLockViewControllerIfNeeded()
	}

	func applicationDidEnterBackground(application: UIApplication) {
		managedObjectContext.saveOrRollback()
		bringDownLockViewController()
	}

	func application(application: UIApplication,
		continueUserActivity userActivity: NSUserActivity,
		restorationHandler: ([AnyObject]?) -> Void) -> Bool {
			guard let noteIdentifier =
				userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
					return  false
			}

			return displayNote(noteIdentifier)
	}

	func application(application: UIApplication,
		openURL url: NSURL,
		sourceApplication: String?,
		annotation: AnyObject) -> Bool {
			debugPrint("OPEN URL \(url)")

			switch (url.host, url.path, url.query) {

				// x2015://note/new
			case ("note"?, "/new"?, nil):
				return createNote()

				// x2015://note/?identifier=<NOTE_IDENTIFIER>
			case ("note"?, _, let query?) where query.containsString("identifier"):
				guard let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: false) else {
					return false
				}
				let queryItems = urlComponents.queryItems
				let noteIdentifierQueryItem = queryItems?.filter({$0.name == "identifier"}).first
				guard let noteIdentifier = noteIdentifierQueryItem?.value else {
					return false
				}
				return displayNote(noteIdentifier)

			default:
				return false
			}
	}

}