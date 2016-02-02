//
//  Foundation+Extensions.swift
//  X2015
//
//  Created by Hang Zhang on 1/9/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

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
