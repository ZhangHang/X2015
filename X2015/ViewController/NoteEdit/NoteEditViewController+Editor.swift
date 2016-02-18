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

	/**
	Loads text onto editor
	This is a Workaround, See [Readme of Marklight](https://github.com/macteo/marklight)

	- parameter text: text to display
	*/
	func loadText_WORKAROUND(text: String?) {
		let attributedString = NSAttributedString(string: text ?? "")
		textView.attributedText = attributedString
		markdownTextStorage.setAttributedString(attributedString)
	}

	/**
	Reload editor while keep selectedRange
	This is a Workaround
	*/
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

	/**
	Update Editor title
	*/
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

	/**
	Update sharing button based on whether note is empty or not
	*/
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
			// ignore everthing if markdown shortcut handler is processing
			if markdownShortcutHandlerIsEditing {
				return false
			}

			// try to provide auto completion for markdown list
			if markdownShortcutHandler!.processListSymbolIfNeeded(
				range,
				replacementText: text) {
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
