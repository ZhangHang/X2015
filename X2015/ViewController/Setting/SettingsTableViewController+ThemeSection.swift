//
//  SettingsTableViewController+ThemeSection.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension SettingsTableViewController {

	func cellForThemeSectionAtRow(row: Int) -> UITableViewCell {
		guard let cellType = ThemeSection(rawValue: row) else { fatalError() }

		func autoThemeCell() -> UITableViewCell {
			let cell = dequeueSettingSwitchCell()
			cell.configure(
				ThemeSection.AutoTheme.title,
				switchOn: settings.automaticallyAdjustsTheme,
				switchTarget: self,
				switchSelector: "handleAutoThemeSwitchValueChanged:")
			return cell
		}
		func defualtThemeCell() -> UITableViewCell {
			let cell = dequeueSettingCheckableCell()
			cell.configure(ThemeSection.DefaultTheme.title, checked: currentTheme == .Default)
			return cell
		}
		func nightThemeCell() -> UITableViewCell {
			let cell = dequeueSettingCheckableCell()
			cell.configure(ThemeSection.NightTheme.title, checked: currentTheme == .Night)
			return cell
		}

		switch cellType {
		case .AutoTheme:
			return autoThemeCell()
		case .DefaultTheme:
			return defualtThemeCell()
		case .NightTheme:
			return nightThemeCell()
		default:
			fatalError()
		}
	}

	func numberOFRowInThemeSection() -> Int {
		if settings.automaticallyAdjustsTheme {
			return 1
		}
		return ThemeSection.numberOfRow
	}

	func footerTitleForThemeSection() -> String? {
		if settings.automaticallyAdjustsTheme {
			return ThemeSection.footerText
		}
		return nil
	}

	func didSelectThemeSectionCell(indexPath: NSIndexPath) {
		guard let cellType = ThemeSection(rawValue: indexPath.row) else { fatalError() }
		switch cellType {
		case .AutoTheme:
			return
		case .DefaultTheme:
			ThemeManager.sharedInstance.userSelectedTheme = .Default
		case .NightTheme:
			ThemeManager.sharedInstance.userSelectedTheme = .Night
		default:
			fatalError()
		}

		guard ThemeManager.sharedInstance.synchronizeWithSettings() else {
			fatalError()
		}
		tableView.reloadSections(NSIndexSet(index: Section.Theme.rawValue), withRowAnimation: .None)
	}

	@objc
	private func handleAutoThemeSwitchValueChanged(sender: UISwitch) {
		ThemeManager.sharedInstance.automaticallyAdjustsTheme = sender.on
		guard ThemeManager.sharedInstance.synchronizeWithSettings() else {
			fatalError()
		}
		tableView.reloadSections(NSIndexSet(index: Section.Theme.rawValue), withRowAnimation: .Automatic)
	}

}
