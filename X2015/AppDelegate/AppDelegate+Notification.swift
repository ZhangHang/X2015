//
//  AppDelegate+Notification.swift
//  X2015
//
//  Created by Hang Zhang on 2/28/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension AppDelegate {

	func registerForRemoteNotifications() {
		let settings = UIUserNotificationSettings(forTypes: [.Badge, .Alert, .Sound], categories: nil)
		UIApplication.sharedApplication().registerUserNotificationSettings(settings)
		UIApplication.sharedApplication().registerForRemoteNotifications()
	}

	func application(
		application: UIApplication,
		didFailToRegisterForRemoteNotificationsWithError error: NSError) {
			debugPrint("didFailToRegisterForRemoteNotificationsWithError \(error)")
	}

	func application(
		application: UIApplication,
		didReceiveLocalNotification notification: UILocalNotification) {
			debugPrint("didReceiveLocalNotification \(notification)")
	}

	func application(
		application: UIApplication,
		didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
			debugPrint("didReceiveRemoteNotification \(userInfo)")
	}

	func application(
		application: UIApplication,
		didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
			debugPrint("didRegisterForRemoteNotificationsWithDeviceToken \(deviceToken)")

			let characterSet = NSCharacterSet(charactersInString: "<>")
			let deviceTokenString = deviceToken
				.description
				.stringByTrimmingCharactersInSet(characterSet)
				.stringByReplacingOccurrencesOfString(" ", withString: "")

			print("decoded device token \(deviceTokenString)")

			NSUserDefaults.standardUserDefaults().remoteNotificationDeviceToken = deviceTokenString
	}

	func application(
		application: UIApplication,
		didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
			debugPrint("didRegisterUserNotificationSettings \(notificationSettings)")
	}

}
