//
//  MarkdownShortcutHandlerTest.swift
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

class MarkdownShortcutHandlerTest: XCTestCase {

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

extension MarkdownShortcutHandlerTest {

	//x         = x
	//ooooooooo = ooooooooo
	func testMoveCursorLeftAtStringHead() {
		let rangeProvider = RangeProvider(range: NSMakeRange(0, 0))
		let handler = MarkdownShortcutHandler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.moveCursorLeft()
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(0, 0)))
	}

	//  x       =  x
	//ooooooooo = ooooooooo
	func testMoveCursorLeftAtStringBody() {
		let rangeProvider = RangeProvider(range: NSMakeRange(1, 0))
		let handler = MarkdownShortcutHandler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.moveCursorLeft()
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(0, 0)))
	}

	//        x =         x
	//ooooooooo = ooooooooo
	func testMoveCursorRightAtStringTail() {
		let endSelectionRange = NSMakeRange(textProvider.string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), 0)
		let rangeProvider = RangeProvider(range: endSelectionRange)
		let handler = MarkdownShortcutHandler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.moveCursorRight()
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, endSelectionRange))
	}

	//     xx   =        x
	//ooooooooo = ooooooooo
	func testMoveCursorRightWithMultipleCharacterSelected() {
		let rangeProvider = RangeProvider(range: NSMakeRange(0, 2))
		let handler = MarkdownShortcutHandler(rangeProvider: rangeProvider, textProvider: textProvider)
		handler.moveCursorRight()
		XCTAssert(NSEqualRanges(rangeProvider.selectedRange, NSMakeRange(3, 0)))
	}

}
