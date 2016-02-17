//
//  MarkdownShortcutHandler.swift
//  X2015
//
//  Created by Hang Zhang on 2/17/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

protocol MarkdownShortcutHandlerDelegate: class {

	func markdownShortcutHandlerDidModifyText(handler: MarkdownShortcutHandler) -> Void

	func markdownShortcutHandlerWillBeginEditing(handler: MarkdownShortcutHandler) -> Void

	func markdownShortcutHandlerDidEndEditing(handler: MarkdownShortcutHandler) -> Void

}

// for test
protocol SelectionRangeProvider: class {

	var selectedRange: NSRange { get set }

}

typealias TextProvider = NSMutableAttributedString

extension UITextView: SelectionRangeProvider {}


final class MarkdownShortcutHandler {

	private(set) weak var rangeProviderCache: SelectionRangeProvider?

	private(set) weak var textProviderCache: TextProvider?

	weak var delegate: MarkdownShortcutHandlerDelegate?

	var textProvider: TextProvider {
		return textProviderCache!
	}

	var text: String {
		return textProvider.string
	}

	var selectedRange: NSRange {
		get {
			return rangeProviderCache!.selectedRange
		}
		set {
			rangeProviderCache!.selectedRange = newValue
		}
	}

	init(rangeProvider: SelectionRangeProvider, textProvider: TextProvider) {
		self.textProviderCache = textProvider
		self.rangeProviderCache = rangeProvider
	}

	init(textView: UITextView, textStorage: NSTextStorage) {
		self.textProviderCache = textStorage
		self.rangeProviderCache = textView
	}

}

extension MarkdownShortcutHandler {

	func beginEditing() {
		delegate?.markdownShortcutHandlerWillBeginEditing(self)
	}

	func endEditing() {
		delegate?.markdownShortcutHandlerDidEndEditing(self)
	}
}

extension MarkdownShortcutHandler {

	func moveCursorLeft() {
		beginEditing()
		selectedRange = NSMakeRange(max(0, selectedRange.location - 1), 0)
		delegate?.markdownShortcutHandlerDidModifyText(self)
		endEditing()
	}

	func moveCursorRight() {
		beginEditing()
		let stringLength = text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
		selectedRange = NSMakeRange(min(stringLength + 1, selectedRange.location + 1), 0)
		delegate?.markdownShortcutHandlerDidModifyText(self)
		endEditing()
	}

	func addHeaderSymbolIfNeeded() {
		beginEditing()
		let string = text
		let paragraphRange = (string as NSString).paragraphRangeForRange(selectedRange)
		let startCharacterOfParagraph = string[string.startIndex.advancedBy(paragraphRange.location)]
		if startCharacterOfParagraph == "#" {
			let stringToInsert = NSAttributedString(string: "#")
			textProvider.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
			selectedRange = NSMakeRange(selectedRange.location + 1, 0)
		} else {
			let stringToInsert = NSAttributedString(string: "# ")
			textProvider.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
			selectedRange = NSMakeRange(selectedRange.location + 2, 0)
		}
		delegate?.markdownShortcutHandlerDidModifyText(self)
		endEditing()
	}

	func addIndentSymbol() {
		beginEditing()
		let stringToInsert = NSAttributedString(string: "\t")
		textProvider.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
		selectedRange = NSMakeRange(selectedRange.location + 1, 0)
		delegate?.markdownShortcutHandlerDidModifyText(self)
		endEditing()
	}

	func addQuoteSymbol() {
		beginEditing()
		let stringToInsert = NSAttributedString(string: "> ")
		let paragraphRange = (textProvider.string as NSString).paragraphRangeForRange(selectedRange)
		textProvider.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
		selectedRange = NSMakeRange(
			selectedRange.location + stringToInsert.string.characters.count,
			0)
		delegate?.markdownShortcutHandlerDidModifyText(self)
		endEditing()
	}

	func addEmphSymbol() {
		beginEditing()
		let stringToInsert = NSAttributedString(string: "*")
		textProvider.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
		selectedRange = NSMakeRange(selectedRange.location + 1, 0)
		delegate?.markdownShortcutHandlerDidModifyText(self)
		endEditing()
	}

	func addLinkSymbol() {
		beginEditing()
		let titleString = NSLocalizedString("Title", comment: "")
		let linkString = NSLocalizedString("Link", comment: "")
		let stringToInsert = NSAttributedString(string: "[\(titleString)](\(linkString))")
		textProvider.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
		selectedRange = NSMakeRange(
			selectedRange.location + 1,
			titleString.characters.count)
		delegate?.markdownShortcutHandlerDidModifyText(self)
		endEditing()
	}


	func makeTextBold() {
		beginEditing()
		let string = text as NSString

		if selectedRange.length > 0 {
			let selectedString = string.substringWithRange(selectedRange)
			let stringToInsert = NSAttributedString(string: "**\(selectedString)**")
			textProvider.replaceCharactersInRange(selectedRange, withAttributedString: stringToInsert)

			var newSelectedRange = selectedRange
			newSelectedRange.length += 4
			selectedRange = newSelectedRange
		} else {
			let stringToInsert = NSAttributedString(string: "****")
			textProvider.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
			selectedRange = NSMakeRange(selectedRange.location + 2, 0)
		}
		delegate?.markdownShortcutHandlerDidModifyText(self)
		endEditing()
	}

	func makeTextItalic() {
		beginEditing()
		let string = text as NSString

		if selectedRange.length > 0 {
			let selectedString = string.substringWithRange(selectedRange)
			let stringToInsert = NSAttributedString(string: "*\(selectedString)*")
			textProvider.replaceCharactersInRange(selectedRange, withAttributedString: stringToInsert)

			var newSelectedRange = selectedRange
			newSelectedRange.length += 2
			selectedRange = newSelectedRange
		} else {
			let stringToInsert = NSAttributedString(string: "**")
			textProvider.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
			selectedRange = NSMakeRange(selectedRange.location + 1, 0)
		}
		delegate?.markdownShortcutHandlerDidModifyText(self)
		endEditing()
	}

	func makeTextList() {
		beginEditing()
		let string = text as NSString

		let paragraphRange = string.paragraphRangeForRange(selectedRange)
		let paragraphString = string.substringWithRange(paragraphRange)
		if paragraphString.hasPrefix("- ") {
			textProvider.replaceCharactersInRange(NSMakeRange(paragraphRange.location, 2), withString: "")
			selectedRange = NSMakeRange(selectedRange.location - 2, 0)
		} else {
			let stringToInsert = NSAttributedString(string: "- ")
			textProvider.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
			selectedRange = NSMakeRange(selectedRange.location + 2, 0)
		}
		delegate?.markdownShortcutHandlerDidModifyText(self)
		endEditing()
	}

}
