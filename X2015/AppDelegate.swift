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

	var window: UIWindow?
	var launchedShortcutItem: UIApplicationShortcutItem?

	var managedObjectContext: NSManagedObjectContext! {
		return managedObjectContextHelper.managedObjectContext
	}
	let managedObjectContextHelper = ManagedContextHelper()

	private var rootViewControllerCache: UISplitViewController?
	private var lockViewController: LockViewController?

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
		window!.rootViewController = lockViewController
	}


	func application(application: UIApplication,
		continueUserActivity userActivity: NSUserActivity,
		restorationHandler: ([AnyObject]?) -> Void) -> Bool {
			guard let noteIdentifier =
				userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
				return  false
			}

			guard let nc = rootViewControllerCache!.childViewControllers.first
				as? UINavigationController else { return false }
			guard let vc = nc.childViewControllers.first
				as? NoteTimelineTableViewController else { return false }

			vc.handleEditNoteUserActivity(noteIdentifier: noteIdentifier)

			return true
	}

}

extension AppDelegate: UISplitViewControllerDelegate {

	private func setupControllers() {
		guard let splitViewController = window!.rootViewController
			as? UISplitViewController else {
				fatalError()
		}
		splitViewController.delegate = self
		guard let masterNavigationController = splitViewController.childViewControllers.first
			as? UINavigationController else {
				fatalError()
		}
		guard let detailNavigationContoller = splitViewController.childViewControllers.last
			as? UINavigationController else {
				fatalError()
		}
		guard let noteTimelineViewController = masterNavigationController.childViewControllers.first
			as? NoteTimelineTableViewController else {
				fatalError()
		}
		guard let _ = detailNavigationContoller.childViewControllers.first
			as? NoteEditViewController else {
				fatalError()
		}

		noteTimelineViewController.managedObjectContext = managedObjectContext
	}

	func splitViewController(splitViewController: UISplitViewController,
		collapseSecondaryViewController secondaryViewController: UIViewController,
		ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
			guard let secondaryAsNavController = secondaryViewController
				as? UINavigationController else { return false }
			guard let topAsDetailController = secondaryAsNavController.topViewController
				as? NoteEditViewController else { return false }
			switch topAsDetailController.noteActionMode {
			case .Empty:
				return true
			default:
				return false
			}
	}

}

extension AppDelegate {

	private func configureInterface() {
		ThemeManager.sharedInstance.register(UITableView)
		ThemeManager.sharedInstance.register(UITextView)
		ThemeManager.sharedInstance.register(UIWindow)
		ThemeManager.sharedInstance.register(UISearchBar)
		ThemeManager.sharedInstance.register(UITextField)
		ThemeManager.sharedInstance.register(UINavigationController)
		ThemeManager.sharedInstance.synchronizeWithSettings()
	}

	private func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
		guard let shortcutIdentifier = ShortcutIdentifier(fullType: shortcutItem.type) else { return false }

		switch shortcutIdentifier {
		case .NewNote:
			guard let nc = rootViewControllerCache!.childViewControllers.first
				as? UINavigationController else { return false }
			guard let vc = nc.childViewControllers.first
				as? NoteTimelineTableViewController else { return false }
			vc.handleNewNoteShortcut()
			return true
		}
	}

}

extension AppDelegate {

	private func setupLockViewController() {
		lockViewController = LockViewController.instanceFromStoryboard()
	}

	private func bringUpLockViewControllerIfNeeded(completion: ( () -> Void )? = nil ) {
		if !LockViewController.needTouchIDAuth {
			bringDownLockViewController()
			completion?()
			return
		}

		lockViewController!.authSuccessHandler = { [unowned self] in
			self.bringDownLockViewController()
			completion?()
		}
		lockViewController!.authFailedHandler = {
			fatalError()
		}
		window!.rootViewController = lockViewController
		lockViewController!.performTouchIDAuth()
	}

	private func bringDownLockViewController() {
		window!.rootViewController = rootViewControllerCache
	}
}
