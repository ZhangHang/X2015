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
				discoverabilityTitle: "New Note"),

			UIKeyCommand(input: "f",
				modifierFlags: .Command,
				action: "handleSearchNoteKeyboardshortcut:",
				discoverabilityTitle: "Find…"),
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

}
