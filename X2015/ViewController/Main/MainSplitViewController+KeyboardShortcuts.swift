//
//  MainSplitViewController+KeyboardShortcuts.swift
//  X2015
//
//  Created by Hang Zhang on 2/7/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension MainSplitViewController {

	override var keyCommands: [UIKeyCommand]? {
		return [
			UIKeyCommand(input: "n",
				modifierFlags: .Command,
				action: "handleNewNoteKeyboardshortcut:",
				discoverabilityTitle: NSLocalizedString("Create Note", comment: "")),

			UIKeyCommand(input: "f",
				modifierFlags: .Command,
				action: "handleSearchNoteKeyboardshortcut:",
				discoverabilityTitle: NSLocalizedString("Find...", comment: "")),
			UIKeyCommand(input: UIKeyInputDownArrow,
				modifierFlags: .Command,
				action: "handleSelectNextNoteShortcut:",
				discoverabilityTitle: NSLocalizedString("Select Next Note", comment: "")),

			UIKeyCommand(input: UIKeyInputUpArrow,
				modifierFlags: .Command,
				action: "handleSelectPreviousNoteShortcut:",
				discoverabilityTitle: NSLocalizedString("Select Previous Note", comment: ""))
		]
	}

	@objc
	private func handleNewNoteKeyboardshortcut(command: UIKeyCommand) {
		debugPrint("handleNewNoteKeyboardshortcut")
		createNote()
	}

	@objc
	private func handleSearchNoteKeyboardshortcut(command: UIKeyCommand) {
		debugPrint("handleSearchNoteKeyboardshortcut")
		focusOnSearchBar()
	}

	@objc
	private func handleSelectNextNoteShortcut(command: UIKeyCommand) {
		noteTimelineViewController.handleSelectNextNoteShortcut()
	}

	@objc
	private func handleSelectPreviousNoteShortcut(command: UIKeyCommand) {
		noteTimelineViewController.handleSelectPreviousNoteShortcut()
	}

}
