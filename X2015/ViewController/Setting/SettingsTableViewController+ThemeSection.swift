//
//  SettingsTableViewController+ThemeSection.swift
//  X2015
//
//  Created by Hang Zhang on 2/16/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

extension SettingsTableViewController {

	enum ThemeSection: Int, TableViewSection {
		case AutoTheme = 0
		case DefaultTheme
		case NightTheme

		//swiftlint:disable variable_name
		//swiftlint:disable type_name
		case COUNT_USE_ONLY_DO_NOT_USE
		static var numberOfRow: Int {
			if ThemeManager.sharedInstance.automaticallyAdjustsTheme {
				return 1
			}
			return ThemeSection.COUNT_USE_ONLY_DO_NOT_USE.rawValue
		}
		//swiftlint:enable variable_name
		//swiftlint:enable type_name

		static var headerText: String? {
			return NSLocalizedString("Theme", comment: "")
		}

		static var footerText: String? {
			if ThemeManager.sharedInstance.automaticallyAdjustsTheme {
				return NSLocalizedString(
					"The theme will automatically change based on your display brightness",
					comment: "")
			}
			return nil
		}

		var title: String {
			switch self {
			case .AutoTheme:
				return NSLocalizedString("Switch Automatically", comment: "")
			case .DefaultTheme:
				return NSLocalizedString("Default", comment: "")
			case .NightTheme:
				return NSLocalizedString("Night", comment: "")
			default:
				fatalError()
			}
		}

	}

	func cellForThemeSectionAtRow(row: Int) -> UITableViewCell {
		guard let cellType = ThemeSection(rawValue: row) else { fatalError() }

		func autoThemeCell() -> UITableViewCell {
			let cell = dequeueSettingSwitchCell()
			cell.configure(
				ThemeSection.AutoTheme.title,
				switchOn: ThemeManager.sharedInstance.automaticallyAdjustsTheme,
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
		tableView.reloadSections(NSIndexSet(index: indexOfSection(ThemeSection.self)!), withRowAnimation: .None)
	}

	@objc
	private func handleAutoThemeSwitchValueChanged(sender: UISwitch) {
		ThemeManager.sharedInstance.automaticallyAdjustsTheme = sender.on
		guard ThemeManager.sharedInstance.synchronizeWithSettings() else {
			fatalError()
		}
		tableView.reloadSections(NSIndexSet(index: indexOfSection(ThemeSection.self)!), withRowAnimation: .None)
	}

}
