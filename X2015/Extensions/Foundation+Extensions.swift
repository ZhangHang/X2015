//
//  Foundation+Extensions.swift
//  X2015
//
//  Created by Hang Zhang on 1/9/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

extension String {

    func lineWithContent(index: UInt) -> String? {

        var lineWithContentCount: UInt = 0

        var line: String?

        enumerateLines({ (_line, stop) -> () in
            if _line.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                if index == lineWithContentCount {
                    line = _line
                    stop = true
                }
                lineWithContentCount += 1
            }
        })

        return line
    }

}
