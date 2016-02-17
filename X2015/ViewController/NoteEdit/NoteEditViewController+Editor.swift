//
//  NoteEditViewController+Editor.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension NoteEditViewController {

	func configureEditor() {
		guard let inputAccessoryView = MarkdownInputAccessoryView.instantiateFromNib() else {
			fatalError()
		}
		({
			$0.configureTheme(currentTheme)
			$0.rightArrowButton.target = self
			$0.leftArrowButton.target = self
			$0.indentButton.target = self
			$0.headerButton.target = self
			$0.listButton.target = self
			$0.emphButton.target = self
			$0.linkButton.target = self
			$0.qouteButton.target = self

			$0.leftArrowButton.action = "handleLeftArrowButtonPressed"
			$0.rightArrowButton.action = "handleRightArrowButtonPressed"
			$0.indentButton.action = "handleIndentButtonPressed"
			$0.headerButton.action = "handleHeaderButtonPressed"
			$0.listButton.action = "handleListButtonPressed"
			$0.emphButton.action = "handleEmphButtonPressed"
			$0.linkButton.action = "handleLinkButtonPressed"
			$0.qouteButton.action = "handleQuoteButtonPressed"
		})(inputAccessoryView)

		({
			// remove original layout manager from default textStorage
			$0.textStorage.removeLayoutManager($0.layoutManager)
			$0.textContainerInset = UIEdgeInsetsMake(4, 4, 4, 4)
			$0.inputAccessoryView = inputAccessoryView
		})(textView)

		markdownTextStorage.addLayoutManager(textView.layoutManager)
		markdownShortcutHandler = MarkdownShortcutHandler(textView: textView, textStorage: markdownTextStorage)
		markdownShortcutHandler?.delegate = self
	}

	// MARK: Workaround, See [Readme of Marklight](https://github.com/macteo/marklight)
	func loadText_WORKAROUND(text: String?) {
		let attributedString = NSAttributedString(string: text ?? "")
		textView.attributedText = attributedString
		markdownTextStorage.setAttributedString(attributedString)
	}

	// Reload text while keep selectedRange
	func refreshTextView_WORKAROUND() {
		markdownTextStorage.insertAttributedString(NSAttributedString(string: ""), atIndex: 0)
	}

	// MARK: AccessoryView Methods
	@objc
	private func handleLeftArrowButtonPressed() {
		markdownShortcutHandler?.moveCursorLeft()
	}

	@objc
	func handleRightArrowButtonPressed() {
		markdownShortcutHandler?.moveCursorRight()
	}

	@objc
	private func handleHeaderButtonPressed() {
		markdownShortcutHandler?.addHeaderSymbolIfNeeded()
	}

	@objc
	private func handleIndentButtonPressed() {
		markdownShortcutHandler?.addIndentSymbol()
	}

	@objc
	private func handleQuoteButtonPressed() {
		markdownShortcutHandler?.addQuoteSymbol()
	}

	@objc
	private func handleListButtonPressed() {
		markdownShortcutHandler?.makeTextList()
	}

	@objc
	private func handleEmphButtonPressed() {
		markdownShortcutHandler?.addEmphSymbol()
	}

	@objc
	private func handleLinkButtonPressed() {
		markdownShortcutHandler?.addLinkSymbol()
	}

	// MARK
	// return true if handled
	func processListSymbolIfNeeded(editedRange: NSRange, replacementText text: String) -> Bool {
		if text == "-" && editedRange.length == 0 {
			let (_, paragraphRange) = noteParagraph(editedRange)
			if paragraphRange.location != editedRange.location { return false }
			// insert a space
			markdownTextStorage.replaceCharactersInRange(NSMakeRange(editedRange.location, 0), withString: "- ")
			textView.selectedRange = NSMakeRange(editedRange.location + 2, 0)
			return true
		}

		if text == "\n" {
			guard let (_, paragraphRange) = noteParagraphWithPrefix("- ", range: editedRange) else {
				// not a list
				return false
			}

			let listPrefix = "- "

			// skip if last paragraph has no content
			// remove list symbol from last paragraph
			if paragraphRange.length == listPrefix.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
				markdownTextStorage.replaceCharactersInRange(NSMakeRange(paragraphRange.location, 2), withString: "\n")
				textView.selectedRange = NSMakeRange(paragraphRange.location + 1, 0)
				return true
			}

			// insert list symbol
			let stringToInsert = NSAttributedString(string: "\n- ")
			let insertIndex = editedRange.location + editedRange.location
			let nextSelectedIndex = insertIndex + stringToInsert.length
			markdownTextStorage.insertAttributedString(stringToInsert, atIndex: editedRange.location)
			textView.selectedRange = NSMakeRange(nextSelectedIndex + 2, 0)
			return true
		}

		return false
	}
}

extension NoteEditViewController {

	func noteParagraph(range: NSRange) -> (String?, NSRange) {
		let string = markdownTextStorage.string
		let paragraphRange = (string as NSString).paragraphRangeForRange(range)

		if paragraphRange.length == 0 { return (nil, paragraphRange) }

		let paragraphString = (string as NSString).substringWithRange(paragraphRange)
		return (paragraphString, paragraphRange)
	}

	func noteParagraphWithPrefix(prefix: String, range: NSRange) -> (String, NSRange)? {
		let (paragraphString, paragraphRange) = noteParagraph(range)

		if let string = paragraphString where string.hasPrefix(prefix) {
			return (string, paragraphRange)
		}

		return nil
	}

}

extension NoteEditViewController: MarkdownShortcutHandlerDelegate {

	func markdownShortcutHandlerDidModifyText(handler: MarkdownShortcutHandler) {
		noteUpdater?.updateNote(markdownTextStorage.string)
	}

	func markdownShortcutHandlerWillBeginEditing(handler: MarkdownShortcutHandler) {
		markdownShortcutHandlerIsEditing = true
	}

	func markdownShortcutHandlerDidEndEditing(handler: MarkdownShortcutHandler) {
		markdownShortcutHandlerIsEditing = false
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
			if markdownShortcutHandlerIsEditing {
				return false
			}

			if processListSymbolIfNeeded(range, replacementText: text) {
				return false
			}

			return true
	}

	//swiftlint:disable variable_name
	func textView(textView: UITextView,
		shouldInteractWithURL URL: NSURL,
		inRange characterRange: NSRange) -> Bool {
			return true
	}
	//swiftlint:enable variable_name

}
