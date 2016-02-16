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
		textView.textContainerInset = UIEdgeInsetsMake(4, 4, 4, 4)
		markdownTextStorage.addLayoutManager(textView.layoutManager)
	}

	// MARK: Workaround, See [Readme of Marklight](https://github.com/macteo/marklight)
	func loadText_WORKAROUND(text: String?) {
		let attributedString = NSAttributedString(string: text ?? "")
		textView.attributedText = attributedString
		markdownTextStorage.appendAttributedString(attributedString)
	}

	// Reload text while keep selectedRange
	func refreshTextView_WORKAROUND() {
		let selectedRange = textView.selectedRange
		let attributedString = NSAttributedString(string: markdownTextStorage.string)
		textView.attributedText = attributedString
		markdownTextStorage.setAttributedString(attributedString)
		textView.selectedRange = selectedRange
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
