//
//  LockViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/21/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class LockViewController: UIViewController {

	var authSuccessHandler: ( () -> Void )?
	var authFailedHandler: ( () -> Void )?

	func performTouchIDAuth() {
		assert(LockViewController.needTouchIDAuth && TouchIDHelper.hasTouchID)
		TouchIDHelper.auth(
			NSLocalizedString("Use Touch ID to Unlock", comment: ""),
			successHandler: { [unowned self] () -> Void in
				self.authSuccessHandler?()
			}) { [unowned self] (errorMessage) -> Void in
				self.authFailedHandler?()
		}
	}

	override func viewWillAppear(animated: Bool) {
		updateThemeInterface()
		super.viewWillAppear(animated)
	}
}

extension LockViewController: SotyboardCreatable {

	static var storyboardName: String {
		return "Main"
	}

	static var viewControllerIdentifier: String {
		return "LockViewController"
	}

}

extension LockViewController {

	static var needTouchIDAuth: Bool {
		return Settings().unlockByTouchID
	}

}

extension LockViewController: ThemeAdaptable {}
