//
//  AppDelegate+Interface.swift
//  X2015
//
//  Created by Hang Zhang on 2/6/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension AppDelegate {

	func configureInterface() {
		ThemeManager.sharedInstance.register([
			UITableView.self,
			UITextView.self,
			UIWindow.self,
			UISearchBar.self,
			UITextField.self,
			UIBarButtonItem.self,
			UINavigationBar.self,
			UINavigationController.self])
		ThemeManager.sharedInstance.restoreFromSettings()
	}

}
