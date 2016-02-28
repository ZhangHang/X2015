//
//  RichFormatTextViewShortcutHandlerTest.swift
//  X2015
//
//  Created by Hang Zhang on 2/17/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import XCTest
@testable import X2015

final class RangeProvider: SelectionRangeProvider {

	var selectedRange: NSRange

	init(range: NSRange) {
		selectedRange = range
	}

}

class RichFormatTextViewShortcutHandlerTest: XCTestCase {

	typealias Handler = RichFormatTextViewShortcutHandler

	let note = [
		"first line",
		"second line",
		"list",
		"- item 1",
		"- item 2",
		"- "
		].joinWithSeparator("\n")

	var textProvider: NSMutableAttributedString!

	override func setUp() {
		super.setUp()
		textProvider = NSMutableAttributedString(string: note)
	}

	override func tearDown() {
		textProvider = nil
		super.tearDown()
	}

}

// MARK: Cursor-moving tests
extension RichFormatTextViewShortcutHandlerTest {

	//x         = x
	//ooooooooo = ooooooooo
	func testMoveCursorLeftAtStringHead() {
		let rangeProvider = RangeProvider(range: NSMakeRange(0, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.moveCursorLeft()
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(0, 0)))
	}

	//  x       =  x
	//ooooooooo = ooooooooo
	func testMoveCursorLeftAtStringBody() {
		let rangeProvider = RangeProvider(range: NSMakeRange(1, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.moveCursorLeft()
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(0, 0)))
	}

	//        x =         x
	//ooooooooo = ooooooooo
	func testMoveCursorRightAtStringTail() {
		let endSelectionRange = NSMakeRange(textProvider.string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), 0)
		let rangeProvider = RangeProvider(range: endSelectionRange)
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.moveCursorRight()
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, endSelectionRange))
	}

	//     xx   =        x
	//ooooooooo = ooooooooo
	func testMoveCursorRightWithMultipleCharacterSelected() {
		let rangeProvider = RangeProvider(range: NSMakeRange(0, 2))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.moveCursorRight()
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(3, 0)))
	}

}

// MARK: Header symbol tests
extension RichFormatTextViewShortcutHandlerTest {

	func testAddHeaderSymbolIfNeededWithNromalLine() {
		let textProvider = TextProvider(string: "title")
		let rangeProvider = RangeProvider(range: NSMakeRange(0, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.addHeaderSymbolIfNeeded()
		XCTAssert(textProvider.string == "# title")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(2, 0)))
	}

	func testAddHeaderSymbolIfNeededWithHeaderLine() {
		let textProvider = TextProvider(string: "# title")
		let rangeProvider = RangeProvider(range: NSMakeRange(0, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)

		handler.addHeaderSymbolIfNeeded()
		XCTAssert(textProvider.string == "## title")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(1, 0)))

		handler.addHeaderSymbolIfNeeded()
//		XCTAssert(textProvider.string == "### title")
//		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(2, 0)))
	}

	func testAddHeaderSymbolIfNeededWithHeaderBrokenLine() {
		let textProvider = TextProvider(string: "#title")
		let rangeProvider = RangeProvider(range: NSMakeRange(0, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.addHeaderSymbolIfNeeded()
		XCTAssert(textProvider.string == "# #title")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(2, 0)))
	}


	func testAddHeaderSymbolIfNeededWithEmptyLine() {
		let textProvider = TextProvider(string: "\n")
		let rangeProvider = RangeProvider(range: NSMakeRange(1, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.addHeaderSymbolIfNeeded()
		XCTAssert(textProvider.string == "\n# ")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(3, 0)))
	}

}

// MARK: Indent test
extension RichFormatTextViewShortcutHandlerTest {

	func testAddIndentSymbol() {
		let textProvider = TextProvider(string: "title")
		let rangeProvider = RangeProvider(range: NSMakeRange(1, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.addIndentSymbol()
		XCTAssert(textProvider.string == "t\title")
	}

}

// MARK: Emph test
extension RichFormatTextViewShortcutHandlerTest {

	func testAddEmphSymbol() {
		let textProvider = TextProvider(string: "title")
		let rangeProvider = RangeProvider(range: NSMakeRange(1, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.addEmphSymbol()
		XCTAssert(textProvider.string == "t*itle")
	}

}

// MARK: Link test
extension RichFormatTextViewShortcutHandlerTest {

	func testAddLinkSymbol() {
		let textProvider = TextProvider(string: "title")
		let rangeProvider = RangeProvider(range: NSMakeRange(1, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		let bundle = NSBundle(forClass: Handler.self)
		let titleString = NSLocalizedString("Title", tableName: nil, bundle: bundle, value: "", comment: "")
		let linkString = NSLocalizedString("Link", tableName: nil, bundle: bundle, value: "", comment: "")
		handler.addLinkSymbol()
		XCTAssert(textProvider.string == "t[\(titleString)](\(linkString))itle")
	}

}

// MARK: Bold text test
extension RichFormatTextViewShortcutHandlerTest {

	func testMakeTextBold() {
		let textProvider = TextProvider(string: "title")
		let rangeProvider = RangeProvider(range: NSMakeRange(1, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.makeTextBold()
		XCTAssert(textProvider.string == "t****itle")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(3, 0)))
	}

	func testMakeTextBoldWithMultipleCharacterSelected() {
		let textProvider = TextProvider(string: "title")
		let rangeProvider = RangeProvider(range: NSMakeRange(1, 1))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.makeTextBold()
		XCTAssert(textProvider.string == "t**i**tle")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(3, 1)))
	}

}

// MARK: Italic text test
extension RichFormatTextViewShortcutHandlerTest {

	func testMakeTextItalic() {
		let textProvider = TextProvider(string: "title")
		let rangeProvider = RangeProvider(range: NSMakeRange(1, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.makeTextItalic()
		XCTAssert(textProvider.string == "t**itle")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(2, 0)))
	}

	func testMakeTextItalicWithMultipleCharacterSelected() {
		let textProvider = TextProvider(string: "title")
		let rangeProvider = RangeProvider(range: NSMakeRange(1, 1))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.makeTextItalic()
		XCTAssert(textProvider.string == "t*i*tle")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(2, 1)))
	}

}

// MARK: List test
extension RichFormatTextViewShortcutHandlerTest {

	func testMakeListWithNormalLine() {
		let textProvider = TextProvider(string: "title")
		let rangeProvider = RangeProvider(range: NSMakeRange(1, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.makeTextList()
		XCTAssert(textProvider.string == "- title")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(3, 0)))
	}

	func testMakeListWithListLine() {
		let textProvider = TextProvider(string: "- title")
		let rangeProvider = RangeProvider(range: NSMakeRange(4, 1))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.makeTextList()
		XCTAssert(textProvider.string == "title")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(2, 1)))
	}

}

// MARK: List auto completion
extension RichFormatTextViewShortcutHandlerTest {

	func testListWithWhiteSpaceAutoCompletion() {
		let textProvider = TextProvider(string: "title\n")
		let rangeProvider = RangeProvider(range: NSMakeRange(6, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		let editRange = NSMakeRange(6, 0)
		if !handler.processListSymbolIfNeeded(editRange, replacementText: "-") {
			XCTFail()
		}
		XCTAssert(textProvider.string == "title\n- ")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(8, 0)))
	}

	func testListWithNewListLineAutoCompletion() {
		let textProvider = TextProvider(string: "- title")
		let rangeProvider = RangeProvider(range: NSMakeRange(7, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		let editRange = NSMakeRange(7, 0)
		if !handler.processListSymbolIfNeeded(editRange, replacementText: "\n") {
			XCTFail()
		}
		XCTAssert(textProvider.string == "- title\n- ")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(10, 0)))
	}

	func testListWithRemoveListLineAutoCompletion() {
		let textProvider = TextProvider(string: "- ")
		let rangeProvider = RangeProvider(range: NSMakeRange(2, 0))
		let handler = Handler(rangeProvider: rangeProvider, textProvider: textProvider)
		let editRange = NSMakeRange(2, 0)
		if !handler.processListSymbolIfNeeded(editRange, replacementText: "\n") {
			XCTFail()
		}
		XCTAssert(textProvider.string == "\n")
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(1, 0)))
	}
	
}
