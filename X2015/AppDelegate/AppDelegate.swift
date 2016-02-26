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
import WatchConnectivity

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
	var xWindow: XWindow = XWindow()
	var window: UIWindow? {
		get {
			return xWindow
		}
		set {
			guard let newWindow = newValue as? XWindow else {
				fatalError()
			}
			xWindow = newWindow
		}
	}
	var rootViewControllerCache: UISplitViewController?
	var passcodeViewController: PasscodeViewController! = {
		return PasscodeViewController.instanceFromStoryboard()
	}()

	// MARK: WatchApp
	var session: WCSession? {
		didSet {
			if let session = session {
				session.delegate = self
				session.activateSession()
			}
		}
	}

}

extension AppDelegate {

	// MARK: UIApplicationDelegate
	func application(
		application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [NSObject: AnyObject]?) -> Bool {
			configureCoreData()
			configureInterface()

			// Pass ManagedObjectContext
			({ [unowned self] in
				guard let vc = self.window!.rootViewController as? ManagedObjectContextSettable else {
					fatalError()
				}
				vc.managedObjectContext = self.managedObjectContext
				})()

			// Passcode
			rootViewControllerCache = window!.rootViewController as? UISplitViewController
			if UIApplication.sharedApplication().applicationState == .Active {
				presentPasscodeViewControllerIfNeeded()
			}

			// WatchApp
			configureWatchSessionIfNeeded()

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
		managedObjectContext.performSaveOrRollback()
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
		presentPasscodeViewControllerIfNeeded()
	}

	func applicationDidEnterBackground(application: UIApplication) {
		managedObjectContext.saveOrRollback()
		window?.rootViewController = passcodeViewController
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

			switch (url.scheme, url.host, url.path, url.query) {

			case ("file", _, _, _):
				// file://

				guard
					let string = try? String(contentsOfURL: url),
					let fileName = url.lastPathComponent else {
						return false
				}

				return createNote("\(fileName)\n\(string)")

			case (_, "note"?, "/new"?, nil):
				// x2015://note/new
				return createNote()

			case (_, "note"?, _, let query?) where query.containsString("identifier"):
				// x2015://note/?identifier=<NOTE_IDENTIFIER>
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
