//
//  MainSplitViewController+KeyboardCommands.swift
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
				action: "handleNewNoteKeyboardCommand:",
				discoverabilityTitle: NSLocalizedString("New Note", comment: "")),

			UIKeyCommand(input: "f",
				modifierFlags: .Command,
				action: "handleSearchNoteKeyboardCommand:",
				discoverabilityTitle: NSLocalizedString("Find...", comment: "")),
			UIKeyCommand(input: UIKeyInputDownArrow,
				modifierFlags: .Command,
				action: "handleSelectNextNoteKeyboardcommand:",
				discoverabilityTitle: NSLocalizedString("Select Next Note", comment: "")),

			UIKeyCommand(input: UIKeyInputUpArrow,
				modifierFlags: .Command,
				action: "handleSelectPreviousNoteKeyboardcommand:",
				discoverabilityTitle: NSLocalizedString("Select Previous Note", comment: ""))
		]
	}

	@objc
	private func handleNewNoteKeyboardCommand(command: UIKeyCommand) {
		debugPrint("handleNewNoteKeyboardCommand")
		createNote()
	}

	@objc
	private func handleSearchNoteKeyboardCommand(command: UIKeyCommand) {
		debugPrint("handleSearchNoteKeyboardCommand")
		noteTimelineViewController.enterSearchMode()
	}

	@objc
	private func handleSelectNextNoteKeyboardcommand(command: UIKeyCommand) {
		noteTimelineViewController.selectNextNote()
	}

	@objc
	private func handleSelectPreviousNoteKeyboardcommand(command: UIKeyCommand) {
		noteTimelineViewController.selectPreviousNote()
	}

}
