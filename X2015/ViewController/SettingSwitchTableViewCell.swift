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

}

extension SettingSwitchTableViewCell: ReusableCell {}

extension SettingSwitchTableViewCell {

	func configure(
		title: String,
		switchOn: Bool,
		switchTarget: AnyObject?,
		switchSelector: Selector,
		enabled: Bool = true) {
		settingTitleLabel.text = title
		settingSwitch.removeTarget(nil, action: nil, forControlEvents: .ValueChanged)
		settingSwitch.on = switchOn
		settingSwitch.addTarget(switchTarget,
			action: switchSelector,
			forControlEvents: .ValueChanged)
		settingTitleLabel.enabled = enabled
		settingSwitch.enabled = enabled
	}

}
