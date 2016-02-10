//
//  AppDelegate+Passcode.swift
//  X2015
//
//  Created by Hang Zhang on 2/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

extension AppDelegate {

	func presentPasscodeViewControllerIfNeeded(completion: ( () -> Void )? = nil ) {
		if !PasscodeViewController.needTouchIDAuth {
			dismissPasscodeViewController()
			completion?()
			return
		}

		passcodeViewController.authSuccessHandler = { [unowned self] in
			self.dismissPasscodeViewController()
			completion?()
		}
		passcodeViewController.authFailedHandler = {
			fatalError()
		}

		if window?.rootViewController != passcodeViewController {
			window!.rootViewController = passcodeViewController
		}

		passcodeViewController!.performTouchIDAuth()
	}

	func dismissPasscodeViewController() {
		window!.rootViewController = rootViewControllerCache
	}

}
