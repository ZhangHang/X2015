//
//  AppDelegate+Passcode.swift
//  X2015
//
//  Created by Hang Zhang on 2/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

extension AppDelegate {

	func setupLockViewController() {
		lockViewController = LockViewController.instanceFromStoryboard()
	}

	func bringUpLockViewControllerIfNeeded(completion: ( () -> Void )? = nil ) {
		if !LockViewController.needTouchIDAuth {
			bringDownLockViewController()
			completion?()
			return
		}

		lockViewController!.authSuccessHandler = { [unowned self] in
			self.bringDownLockViewController()
			completion?()
		}
		lockViewController!.authFailedHandler = {
			fatalError()
		}
		window!.rootViewController = lockViewController
		lockViewController!.performTouchIDAuth()
	}

	func bringDownLockViewController() {
		window!.rootViewController = rootViewControllerCache
	}

}
