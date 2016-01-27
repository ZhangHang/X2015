//
//  ThemeAdaptableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

class ThemeAdaptableViewController: UIViewController, ThemeAdaptable {

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NSNotificationCenter
			.defaultCenter()
			.addObserverForName(themeChangeNotification,
				object: nil,
				queue: NSOperationQueue.mainQueue()) {
					[unowned self] (_) -> Void in
					self.updateThemeInterface()
		}
		updateThemeInterface()
	}

}
