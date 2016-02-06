//
//  AppDelegate+Route.swift
//  X2015
//
//  Created by Hang Zhang on 2/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension AppDelegate {

	func createNote() -> Bool {
		guard let vc = unboxTimelineContrtoller() else {
			return false
		}
		vc.handleCreatingNoteRequest()
		return true
	}

	func displayNote(identifier: String) -> Bool {
		guard let vc = unboxTimelineContrtoller() else {
			return false
		}
		vc.handleDisplayNoteRequest(noteIdentifier: identifier)
		return true
	}

	private func unboxTimelineContrtoller() -> NoteTimelineTableViewController? {
		guard
		let nc = rootViewControllerCache!.childViewControllers.first
			as? UINavigationController,
		let vc = nc.childViewControllers.first
			as? NoteTimelineTableViewController else {
				return nil
		}
		return vc
	}

}
