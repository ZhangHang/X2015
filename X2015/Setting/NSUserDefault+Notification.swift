//
//  NSUserDefault+Notification.swift
//  X2015
//
//  Created by Hang Zhang on 2/28/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

private let remoteNotificationDeviceTokenKey = "remoteNotificationDeviceToken"

extension NSUserDefaults {

	var remoteNotificationDeviceToken: String? {
		get {
			return valueForKey(remoteNotificationDeviceTokenKey) as? String
		}
		set {
			setValue(newValue, forKey: remoteNotificationDeviceTokenKey)
		}
	}

}
