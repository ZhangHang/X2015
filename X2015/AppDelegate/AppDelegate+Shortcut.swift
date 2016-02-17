//
//  AppDelegate+Shortcut.swift
//  X2015
//
//  Created by Hang Zhang on 2/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension AppDelegate {

	func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
		guard let shortcutIdentifier = ShortcutIdentifier(fullType: shortcutItem.type) else { return false }

		switch shortcutIdentifier {
		case .NewNote:
			return createNote()
		}
	}

	// MARK
	func createNote() -> Bool {
		guard let vc = unboxMainContrtoller() else {
			return false
		}
		vc.createNote()
		return true
	}

	func displayNote(identifier: String) -> Bool {
		guard let vc = unboxMainContrtoller() else {
			return false
		}
		vc.displayNote(identifier)
		return true
	}

	private func unboxMainContrtoller() -> MainSplitViewController? {
		guard let vc = window?.rootViewController as? MainSplitViewController else {
			return nil
		}
		return vc
	}

}
