//
//  SettingCheckableTableViewCell.swift
//  X2015
//
//  Created by Hang Zhang on 1/28/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class SettingCheckableTableViewCell: UITableViewCell {

	@IBOutlet weak var settingTitleLabel: UILabel!

	var checked: Bool = false {
		didSet {
			accessoryType = checked ? .Checkmark : .None
		}
	}

}

extension SettingCheckableTableViewCell: ReusableCell {}

extension SettingCheckableTableViewCell {

	func configure(title: String, checked: Bool = false) {
		self.checked = checked
		settingTitleLabel.text = title
	}

}
