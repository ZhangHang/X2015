//
//  X2015KitFoundationExtensionTests.swift
//  X2015
//
//  Created by Hang Zhang on 2/17/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import XCTest
@testable import X2015Kit

class X2015KitFoundationExtensionTests: XCTestCase {

	let note = [
		"",
		"X2015 is a dead simple note app",
		"",
		"Feature",
		"- Markdown support",
		"- Theme Support",
		"- Universual app",
		"- etc..."
		].joinWithSeparator("\n")

	// MARK: String
	func testStringContentWithLine() {
		XCTAssertEqual(note.lineWithContent(0), "X2015 is a dead simple note app")
		XCTAssertEqual(note.lineWithContent(1), "Feature")
		XCTAssertEqual(note.lineWithContent(7), nil)
	}

	func testStringEmpty() {
		XCTAssert("".empty == true)
		XCTAssert(" ".empty == false)
		XCTAssert(note.empty == false)
	}

	func testParagraphsRangeForRangeWithStartRange() {
		let range = note.paragraphsRangeForRange(
			Range<String.Index>(
				start: note.startIndex,
				end: note.startIndex))
		XCTAssert(range == Range<String.Index>(start: note.startIndex, end: note.startIndex.advancedBy(1)))
	}

	func testParagraphRangeForRangeWithEndRange() {
		let range = note.paragraphsRangeForRange(
			Range<String.Index>(
				start: note.startIndex,
				end: note.startIndex.advancedBy(2)))
		XCTAssert(range == Range<String.Index>(start: note.startIndex, end: note.startIndex.advancedBy(33)))
	}

	func testParagraphStringForRangeWithEndRange() {
		let range = note.paragraphsRangeForRange(
			Range<String.Index>(
				start: note.startIndex,
				end: note.startIndex.advancedBy(2)))
		let string = note.paragraphsStringForRange(range)
		XCTAssert(string == "\nX2015 is a dead simple note app\n")
	}

}
