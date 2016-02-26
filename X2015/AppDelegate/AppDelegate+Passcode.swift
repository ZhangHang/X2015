//
//  AppDelegate+Passcode.swift
//  X2015
//
//  Created by Hang Zhang on 2/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

extension AppDelegate {

	func setupPasscodeViewControllerIfNeeded() {
		if !NSUserDefaults.standardUserDefaults().unlockByTouchID {
			return
		}

		passcodeViewController = PasscodeViewController.instanceFromStoryboard()!
		guard let viewController = passcodeViewController else {
			fatalError()
		}

		viewController.authSuccessHandler = {
			viewController.dismissViewControllerAnimated(true, completion: { () -> Void in
				self.passcodeViewController = nil
			})
		}
		viewController.authFailedHandler = {
			fatalError()
		}
		window!.rootViewController!.presentViewController(viewController, animated: false, completion: nil)
	}

	func presentPasscodeViewControllerIfNeeded() {
		passcodeViewController?.performTouchIDAuth()
	}

}
