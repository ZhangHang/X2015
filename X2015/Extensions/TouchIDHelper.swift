//
//  TouchIDHelper.swift
//  X2015
//
//  Created by Hang Zhang on 1/19/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import LocalAuthentication

struct TouchIDHelper {
	static var hasTouchID: Bool {
		let context = LAContext()
		return context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: nil)
	}

	static func auth(reason: String, successHandler:() -> Void, errorHandler:(errorMessage: String?) -> Void) {
		let context = LAContext()
		context.evaluatePolicy(
			LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
			localizedReason: reason,
			reply: { (success: Bool, error: NSError? ) -> Void in
				dispatch_async(dispatch_get_main_queue(), {
					if success {
						successHandler()
						return
					}

					if error != nil {
						var errorMessage: String?
						switch error!.code {
						case LAError.AuthenticationFailed.rawValue:
							errorMessage = NSLocalizedString("There was a problem verifying your identity", comment: "")
							break
						case LAError.UserCancel.rawValue:
							errorMessage = ""
							break
						default:
							errorMessage = NSLocalizedString("Touch ID may not be configured", comment: "")
							break
						}
						errorHandler(errorMessage: errorMessage)
						return
					}
				})
		})
	}

}
