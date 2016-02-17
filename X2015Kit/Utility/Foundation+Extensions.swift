//
//  Foundation+Extensions.swift
//  X2015
//
//  Created by Hang Zhang on 1/9/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation
import UIKit

extension String {

    public func lineWithContent(index: UInt) -> String? {
        var lineWithContentCount: UInt = 0
        var line: String?

        enumerateLines({ (_line, stop) -> () in
            if !_line.empty {
                if index == lineWithContentCount {
                    line = _line
                    stop = true
                }
                lineWithContentCount += 1
            }
        })

        return line
    }

	public var empty: Bool {
		return lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
	}

}

extension String {

	public func rangeFromNSRange(range: NSRange) -> Range<String.Index> {
		let start = startIndex.advancedBy(range.location)
		let end = startIndex.advancedBy(range.location + range.length)
		return Range<String.Index>(start: start, end: end)
	}

	public func paragraphsRangeForRange(range: Range<String.Index>) -> Range<String.Index> {
		let startParagraphRange = paragraphRangeForRange(range)
		let endParagraphRange = paragraphRangeForRange(range)
		let wholeRange = Range<String.Index>(
			start: startParagraphRange.startIndex,
			end: endParagraphRange.endIndex)

		return wholeRange
	}

	public func paragraphsRangeForNSRange(range: NSRange) -> Range<String.Index> {
		let nativeRange = rangeFromNSRange(range)
		return paragraphsRangeForRange(nativeRange)
	}

	public func paragraphsStringForRange(range: Range<String.Index>) -> String {
		return substringWithRange(paragraphsRangeForRange(range))
	}

	public func paragraphsStringForNSRange(range: NSRange) -> String {
		let nativeRange = rangeFromNSRange(range)
		return substringWithRange(paragraphsRangeForRange(nativeRange))
	}

}
