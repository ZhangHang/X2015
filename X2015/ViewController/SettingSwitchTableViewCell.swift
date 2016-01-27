//
//  SettingSwitchTableViewCell.swift
//  X2015
//
//  Created by Hang Zhang on 1/27/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class SettingSwitchTableViewCell: UITableViewCell {

	@IBOutlet weak var settingTitleLabel: UILabel!
	@IBOutlet weak var settingSwitch: UISwitch!

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

}

extension SettingSwitchTableViewCell: ConfigureableCell {}

extension SettingSwitchTableViewCell: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		switch theme {
		case .Bright:
			backgroundColor = UIColor.whiteColor()
			settingTitleLabel.textColor = UIColor.bright_MainTextColor()
		case .Dark:
			backgroundColor = UIColor.dark_lightBlackColor()
			settingTitleLabel.textColor = UIColor.dark_MainTextColor()
		}
	}

}
