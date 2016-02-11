//
//  NSUserDefault+TouchID.swift
//  X2015
//
//  Created by Hang Zhang on 2/11/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

private let unlockByTouchIDKey = "unlockByTouchID"

extension NSUserDefaults {

	var unlockByTouchID: Bool {
		get {
			guard let value = valueForKey(unlockByTouchIDKey) as? Bool else {
				setValue(false, forKey: unlockByTouchIDKey)
				return false
			}
			return value
		}
		set {
			setValue(newValue, forKey: unlockByTouchIDKey)
		}
	}

}
