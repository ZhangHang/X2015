//
//  NoteEditViewController+KeyboardCommand.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	override var keyCommands: [UIKeyCommand]? {
		return [
			UIKeyCommand(input: "l",
				modifierFlags: [.Command, .Shift],
				action: "handleMakeTextListKeyboardCommand:",
				discoverabilityTitle: NSLocalizedString("Make List", comment: "")),

			UIKeyCommand(input: "i",
				modifierFlags: [.Command, .Shift],
				action: "handleMakeTextItalicKeyboardCommand:",
				discoverabilityTitle: NSLocalizedString("Make Text Italic", comment: "")),

			UIKeyCommand(input: "b",
				modifierFlags: [.Command, .Shift],
				action: "handleMakeTextBoldKeyboardCommand:",
				discoverabilityTitle: NSLocalizedString("Make Text Bold", comment: ""))
		]
	}

	@objc
	private func handleMakeTextBoldKeyboardCommand(command: UIKeyCommand) {
		debugPrint("handleNewNoteKeyboardCommand")
		textView.shortcutHandler.makeTextBold()
	}

	@objc
	private func handleMakeTextItalicKeyboardCommand(command: UIKeyCommand) {
		debugPrint("handleMakeTextItalicKeyboardCommand")
		textView.shortcutHandler.makeTextItalic()
	}


	@objc
	private func handleMakeTextListKeyboardCommand(command: UIKeyCommand) {
		debugPrint("handleMakeTextListKeyboardCommand")
		textView.shortcutHandler.makeTextList()
	}

}
