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

			UIKeyCommand(input: "e",
				modifierFlags: .Command,
				action: "handleEditNoteKeyboardCommand:",
				discoverabilityTitle: NSLocalizedString("Edit Note", comment: "")),

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
		guard let vc = noteTimelineViewController else {
			fatalError()
		}
		vc.enterSearchMode()
	}

	@objc
	private func handleEditNoteKeyboardCommand(command: UIKeyCommand) {
		debugPrint("handleEditNoteKeyboardCommand")
		guard let vc = noteEditViewController else {
			fatalError()
		}
		vc.startEditingIfNeeded()
	}

	@objc
	private func handleSelectNextNoteKeyboardcommand(command: UIKeyCommand) {
		guard let vc = noteTimelineViewController else {
			fatalError()
		}
		vc.selectNextNote()
	}

	@objc
	private func handleSelectPreviousNoteKeyboardcommand(command: UIKeyCommand) {
		guard let vc = noteTimelineViewController else {
			fatalError()
		}
		vc.selectPreviousNote()
	}

}
