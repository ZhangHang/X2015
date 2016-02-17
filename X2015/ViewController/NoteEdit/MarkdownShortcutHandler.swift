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

}

final class MarkdownShortcutHandler {

	private(set) weak var textViewCache: UITextView?

	private(set) weak var textStorageCahce: NSTextStorage?

	weak var delegate: MarkdownShortcutHandlerDelegate?

	var textView: UITextView {
		return textViewCache!
	}

	var textStorage: NSTextStorage {
		return textStorageCahce!
	}

	var text: String {
		return textStorage.string
	}

	var userSelectedRange: NSRange {
		return textView.selectedRange
	}

	init(textView: UITextView, textStorage: NSTextStorage) {
		self.textStorageCahce = textStorage
		self.textViewCache = textView
	}


}

extension MarkdownShortcutHandler {

	func moveCursorLeft() {
		let selectedRange = userSelectedRange
		textView.selectedRange = NSMakeRange(max(0, selectedRange.location - 1), 0)
		delegate?.markdownShortcutHandlerDidModifyText(self)
	}

	func moveCursorRight() {
		let selectedRange = userSelectedRange
		let stringLength = textView.textStorage.string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
		textView.selectedRange = NSMakeRange(min(stringLength + 1, selectedRange.location + 1), 0)
		delegate?.markdownShortcutHandlerDidModifyText(self)
	}

	func addHeaderSymbolIfNeeded() {
		let string = text
		let selectedRange = userSelectedRange
		let paragraphRange = (string as NSString).paragraphRangeForRange(selectedRange)
		let startCharacterOfParagraph = string[string.startIndex.advancedBy(paragraphRange.location)]
		if startCharacterOfParagraph == "#" {
			let stringToInsert = NSAttributedString(string: "#")
			textStorage.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
			textView.selectedRange = NSMakeRange(selectedRange.location + 1, 0)
		} else {
			let stringToInsert = NSAttributedString(string: "# ")
			textStorage.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
			textView.selectedRange = NSMakeRange(selectedRange.location + 2, 0)
		}
		delegate?.markdownShortcutHandlerDidModifyText(self)
	}

	func addIndentSymbol() {
		let selectedRange = userSelectedRange
		let stringToInsert = NSAttributedString(string: "\t")
		textStorage.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
		textView.selectedRange = NSMakeRange(selectedRange.location + 1, 0)
		delegate?.markdownShortcutHandlerDidModifyText(self)
	}

	func addQuoteSymbol() {
		let selectedRange = userSelectedRange
		let stringToInsert = NSAttributedString(string: "> ")
		let paragraphRange = (textStorage.string as NSString).paragraphRangeForRange(selectedRange)
		textStorage.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
		textView.selectedRange = NSMakeRange(
			selectedRange.location + stringToInsert.string.characters.count,
			0)
		delegate?.markdownShortcutHandlerDidModifyText(self)
	}

	func addEmphSymbol() {
		let selectedRange = userSelectedRange
		let stringToInsert = NSAttributedString(string: "*")
		textStorage.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
		textView.selectedRange = NSMakeRange(selectedRange.location + 1, 0)
		delegate?.markdownShortcutHandlerDidModifyText(self)
	}

	func addLinkSymbol() {
		let selectedRange = userSelectedRange
		let titleString = NSLocalizedString("Title", comment: "")
		let linkString = NSLocalizedString("Link", comment: "")
		let stringToInsert = NSAttributedString(string: "[\(titleString)](\(linkString))")
		textStorage.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
		textView.selectedRange = NSMakeRange(
			selectedRange.location + 1,
			titleString.characters.count)
		delegate?.markdownShortcutHandlerDidModifyText(self)
	}


	func makeTextBold() {
		let selectedRange = userSelectedRange
		let string = textStorage.string

		if selectedRange.length > 0 {
			let selectedString = (string as NSString).substringWithRange(selectedRange)
			let stringToInsert = NSAttributedString(string: "**\(selectedString)**")
			textStorage.replaceCharactersInRange(selectedRange, withAttributedString: stringToInsert)

			var newSelectedRange = selectedRange
			newSelectedRange.length += 4
			textView.selectedRange = newSelectedRange
		} else {
			let stringToInsert = NSAttributedString(string: "****")
			textStorage.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
			textView.selectedRange = NSMakeRange(selectedRange.location + 2, 0)
		}
		delegate?.markdownShortcutHandlerDidModifyText(self)
	}

	func makeTextItalic() {
		let selectedRange = userSelectedRange
		let string = textStorage.string

		if selectedRange.length > 0 {
			let selectedString = (string as NSString).substringWithRange(selectedRange)
			let stringToInsert = NSAttributedString(string: "*\(selectedString)*")
			textStorage.replaceCharactersInRange(selectedRange, withAttributedString: stringToInsert)

			var newSelectedRange = selectedRange
			newSelectedRange.length += 2
			textView.selectedRange = newSelectedRange
		} else {
			let stringToInsert = NSAttributedString(string: "**")
			textStorage.insertAttributedString(stringToInsert, atIndex: selectedRange.location)
			textView.selectedRange = NSMakeRange(selectedRange.location + 1, 0)
		}
		delegate?.markdownShortcutHandlerDidModifyText(self)
	}

	func makeTextList() {
		let selectedRange = userSelectedRange
		let string = textStorage.string

		let paragraphRange = (string as NSString).paragraphRangeForRange(selectedRange)
		let paragraphString = (string as NSString).substringWithRange(paragraphRange)
		if paragraphString.hasPrefix("- ") {
			textStorage.replaceCharactersInRange(NSMakeRange(paragraphRange.location, 2), withString: "")
			textView.selectedRange = NSMakeRange(selectedRange.location - 2, 0)
		} else {
			let stringToInsert = NSAttributedString(string: "- ")
			textStorage.insertAttributedString(stringToInsert, atIndex: paragraphRange.location)
			textView.selectedRange = NSMakeRange(selectedRange.location + 2, 0)
		}
		delegate?.markdownShortcutHandlerDidModifyText(self)
	}

}
