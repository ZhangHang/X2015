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
		guard let inputAccessoryView = MarkdownInputAccessoryView.instantiateFromNib() else {
			fatalError()
		}
		textView.inputAccessoryView = inputAccessoryView
		inputAccessoryView.configureTheme(currentTheme)
		inputAccessoryView.rightArrowButton.target = self
		inputAccessoryView.leftArrowButton.target = self
		inputAccessoryView.indentButton.target = self
		inputAccessoryView.headerButton.target = self
		inputAccessoryView.listButton.target = self
		inputAccessoryView.emphButton.target = self
		inputAccessoryView.linkButton.target = self
		inputAccessoryView.qouteButton.target = self

		inputAccessoryView.leftArrowButton.action = "handleLeftArrowButtonPressed"
		inputAccessoryView.rightArrowButton.action = "handleRightArrowButtonPressed"
		inputAccessoryView.indentButton.action = "handleIndentButtonPressed"
		inputAccessoryView.headerButton.action = "handleHeaderButtonPressed"
		inputAccessoryView.listButton.action = "handleListButtonPressed"
		inputAccessoryView.emphButton.action = "handleEmphButtonPressed"
		inputAccessoryView.linkButton.action = "handleLinkButtonPressed"
		inputAccessoryView.qouteButton.action = "handleQuoteButtonPressed"
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

	// MARK: AccessoryView Methods

	@objc
	private func handleLeftArrowButtonPressed() {
		let selectedRange = textView.selectedRange
		textView.selectedRange = NSMakeRange(max(0, selectedRange.location - 1), 0)
	}

	@objc
	func handleRightArrowButtonPressed() {
		let selectedRange = textView.selectedRange
		let stringLength = textView.textStorage.string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
		textView.selectedRange = NSMakeRange(min(stringLength + 1, selectedRange.location + 1), 0)
	}

	@objc
	private func handleHeaderButtonPressed() {
		let selectedRange = textView.selectedRange
		let string = markdownTextStorage.string

		let paragraphRange = (string as NSString).paragraphRangeForRange(selectedRange)
		let startCharacterOfParagraph = string[string.startIndex.advancedBy(paragraphRange.location)]
		if startCharacterOfParagraph == "#" {
			let stringToInsert = NSAttributedString(string: "#")
			markdownTextStorage.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
			textView.selectedRange = NSMakeRange(selectedRange.location + 1, 0)
		} else {
			let stringToInsert = NSAttributedString(string: "# ")
			markdownTextStorage.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
			textView.selectedRange = NSMakeRange(selectedRange.location + 2, 0)
		}
	}

	@objc
	private func handleIndentButtonPressed() {
		let selectedRange = textView.selectedRange
		let stringToInsert = NSAttributedString(string: "\t")
		markdownTextStorage.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
		textView.selectedRange = NSMakeRange(selectedRange.location + 1, 0)
	}

	@objc
	private func handleQuoteButtonPressed() {
		let selectedRange = textView.selectedRange
		let stringToInsert = NSAttributedString(string: "> ")
		let paragraphRange = (markdownTextStorage.string as NSString).paragraphRangeForRange(selectedRange)
		markdownTextStorage.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
		textView.selectedRange = NSMakeRange(
			selectedRange.location + stringToInsert.string.characters.count,
			0)
	}

	@objc
	private func handleListButtonPressed() {
		let selectedRange = textView.selectedRange
		let string = markdownTextStorage.string
		let paragraphRange = (string as NSString).paragraphRangeForRange(selectedRange)
		let stringToInsert = NSAttributedString(string: "- ")
		markdownTextStorage.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
		textView.selectedRange = NSMakeRange(selectedRange.location + 2, 0)
	}

	@objc
	private func handleEmphButtonPressed() {
		let selectedRange = textView.selectedRange
		let stringToInsert = NSAttributedString(string: "*")
		markdownTextStorage.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
		textView.selectedRange = NSMakeRange(selectedRange.location + 1, 0)
	}

	@objc
	private func handleLinkButtonPressed() {
		let selectedRange = textView.selectedRange
		let titleString = NSLocalizedString("Title", comment: "")
		let linkString = NSLocalizedString("Link", comment: "")
		let stringToInsert = NSAttributedString(string: "[\(titleString)](\(linkString))")
		markdownTextStorage.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
		textView.selectedRange = NSMakeRange(
			selectedRange.location + 1,
			titleString.characters.count)

	}

	// MARK
	func insertListSymbolIfNeeded(editedRange: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			let string = markdownTextStorage.string
			let paragraphRange = (string as NSString).paragraphRangeForRange(editedRange)

			// empty line
			if paragraphRange.length == 0 { return true }

			let paragraphString = (string as NSString).substringWithRange(paragraphRange)
			let listPrefix = "- "

			// not a list
			if !paragraphString.hasPrefix(listPrefix) {
				return true
			}

			// skip if last paragraph has no content
			if paragraphRange.length == listPrefix.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
				return true
			}

			// insert list symbol
			let stringToInsert = NSAttributedString(string: "\n- ")
			let insertIndex = editedRange.location + editedRange.location
			let nextSelectedIndex = insertIndex + stringToInsert.length
			markdownTextStorage.insertAttributedString(stringToInsert, atIndex: editedRange.location)
			textView.selectedRange = NSMakeRange(nextSelectedIndex + 2, 0)
			return false
		}

		return true
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

	func textView(
		textView: UITextView,
		shouldChangeTextInRange range: NSRange,
		replacementText text: String) -> Bool {
			return insertListSymbolIfNeeded(range, replacementText: text)
	}

	//swiftlint:disable variable_name
	func textView(textView: UITextView,
		shouldInteractWithURL URL: NSURL,
		inRange characterRange: NSRange) -> Bool {
			return true
	}
	//swiftlint:enable variable_name
	
}
