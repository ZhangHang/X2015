//
//  LockViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/21/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class LockViewController: ThemeAdaptableViewController {

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

	override func updateThemeInterface(theme: Theme) {
		switch theme {
		case .Bright:
			view.backgroundColor = UIColor.x2015_BlueColor()
		case .Dark:
			view.backgroundColor = UIColor.dark_ViewControllerBackgroundColor()
		}
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
