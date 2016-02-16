//
//  NoteEditViewController+Editor.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	func setupTextView() {
		markdownTextStorage.addLayoutManager(textView.layoutManager)
	}

	// MARK: Workaround, See [Readme of Marklight](https://github.com/macteo/marklight)
	func loadText(text: String?) {
		let attributedString = NSAttributedString(string: text ?? "")
		textView.attributedText = attributedString
		markdownTextStorage.appendAttributedString(attributedString)
	}

}

extension NoteEditViewController: UITextViewDelegate {

	func updateTitleIfNeeded() {
		if let updater = noteUpdater {
			let noteTitle =  updater.noteTitle
			if noteTitle != title {
				title = updater.noteTitle
			}
		} else {
			title = nil
		}
	}

	func updateActionButtonIfNeeded() {
		let isContentEmpty = textView.text.empty

		if actionBarButton.enabled != !isContentEmpty {
			actionBarButton.enabled = !isContentEmpty
		}
	}

	func textViewDidEndEditing(textView: UITextView) {
		navigationController?.setNavigationBarHidden(false, animated: true)
		setNeedsStatusBarAppearanceUpdate()
	}

	func textViewDidChange(textView: UITextView) {
		updateActionButtonIfNeeded()
		noteUpdater!.updateNote(markdownTextStorage.string)
	}

	//swiftlint:disable variable_name
	func textView(textView: UITextView,
		shouldInteractWithURL URL: NSURL,
		inRange characterRange: NSRange) -> Bool {
			return true
	}
	//swiftlint:enable variable_name

}
