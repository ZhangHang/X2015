//
//  RichFormatTextView.swift
//  X2015
//
//  Created by Hang Zhang on 2/18/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import Marklight

protocol RichFormatTextViewDelegate: class {

	func richFormatTextViewDidBeginEditing(textView: RichFormatTextView)
	func richFormatTextViewDidEndEditing(textView: RichFormatTextView)
	func richFormatTextViewDidChange(textView: RichFormatTextView)

}

class RichFormatTextView: UITextView {

	typealias RichFormatTextStorage = MarklightTextStorage

	private(set) var richFormatTextStorage: RichFormatTextStorage!
	private(set) var shortcutHandler: RichFormatTextViewShortcutHandler!

	private(set) var processing: Bool = false

	var didBeginEditing: (() -> Void)?
	var didEndEditing: (() -> Void)?
	var didChange: ((text: String) -> Void)?

	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	private func setup() {
		delegate = self

		setupInputAccessoryView()

		richFormatTextStorage = RichFormatTextStorage()
		richFormatTextStorage.addLayoutManager(layoutManager)
		shortcutHandler = RichFormatTextViewShortcutHandler(
			rangeProvider: self,
			textProvider: richFormatTextStorage)
		shortcutHandler.delegate = self
	}

	var richFormatText: String! {
		return richFormatTextStorage.string
	}

	/**
	Loads text onto editor
	This is a Workaround, See [Readme of Marklight](https://github.com/macteo/marklight)

	- parameter text: text to display
	*/
	func loadText_WORKAROUND(text: String?) {
		let attributedString = NSAttributedString(string: text ?? "")
		richFormatTextStorage.setAttributedString(attributedString)
	}

	/**
	Reload editor while keep selectedRange
	This is a Workaround
	*/
	func refreshTextView_WORKAROUND() {
		richFormatTextStorage.insertAttributedString(NSAttributedString(string: ""), atIndex: 0)
	}

}

extension RichFormatTextView: RichFormatTextViewShortcutHandlerDelegate {

	func richFormatTextViewShortcutHandlerHandlerWillBeginEditing(handler: RichFormatTextViewShortcutHandler) {
		processing = true
	}

	func richFormatTextViewShortcutHandlerHandlerDidEndEditing(handler: RichFormatTextViewShortcutHandler) {
		processing = false
	}

	func richFormatTextViewShortcutHandlerHandlerDidModifyText(handler: RichFormatTextViewShortcutHandler) {
		didChange?(text: richFormatTextStorage.string)
	}

}

extension RichFormatTextView: UITextViewDelegate {

	func textViewDidEndEditing(textView: UITextView) {
		didEndEditing?()
	}

	func textViewDidChange(textView: UITextView) {
		didChange?(text: richFormatTextStorage.string)
	}

	func textView(
		textView: UITextView,
		shouldChangeTextInRange range: NSRange,
		replacementText text: String) -> Bool {
			// ignore everthing if is processing
			if processing {
				return false
			}

			// try to provide auto completion for markdown list
			if shortcutHandler.processListSymbolIfNeeded(range, replacementText: text) {
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
