//
//  Utility.swift
//  X2015
//
//  Created by Hang Zhang on 2/23/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

class Box<T>: NSObject {
	let value: T
	init(value: T) {
		self.value = value
	}
}
