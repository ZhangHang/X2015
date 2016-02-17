//
//  SettingsTableViewController.swift
//  X2015
//
//  Created by Hang Zhang on 1/18/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

protocol TableViewSection {

	static var numberOfRow: Int { get }
	static var headerText: String? { get }
	static var footerText: String? { get }
	var title: String { get }

}

extension TableViewSection {

	static var headerText: String? {
 		return nil
	}

	static var footerText: String? {
		return nil
	}

}

final class SettingsTableViewController: ThemeAdaptableTableViewController {

	enum Section: Int {
		case General = 0
		case Theme

		//swiftlint:disable variable_name
		//swiftlint:disable type_name
		case COUNT_USE_ONLY_DO_NOT_USE
		static var count: Int {
			return Section.COUNT_USE_ONLY_DO_NOT_USE.rawValue
		}
		//swiftlint:enable variable_name
		//swiftlint:enable type_name

		var numberOfRow: Int {
			switch self {
			case .General:
				return GeneralSection.numberOfRow
			case .Theme:
				return ThemeSection.numberOfRow
			default:
				fatalError()
			}
		}

		var headerText: String? {
			switch self {
			case .General:
				return GeneralSection.headerText
			case .Theme:
				return ThemeSection.headerText
			default:
				fatalError()
			}
		}

		var footerText: String? {
			switch self {
			case .General:
				return GeneralSection.footerText
			case .Theme:
				return ThemeSection.footerText
			default:
				fatalError()
			}
		}
	}

	enum GeneralSection: Int, TableViewSection {
		case UnlockByTouchID = 0

		//swiftlint:disable variable_name
		//swiftlint:disable type_name
		case COUNT_USE_ONLY_DO_NOT_USE
		static var numberOfRow: Int {
			return GeneralSection.COUNT_USE_ONLY_DO_NOT_USE.rawValue
		}
		//swiftlint:enable variable_name
		//swiftlint:enable type_name

		static var headerText: String? {
			return NSLocalizedString("General", comment: "")
		}

		static var footerText: String? {
			return nil
		}

		var title: String {
			switch self {
			case .UnlockByTouchID:
				return NSLocalizedString("Touch ID", comment: "")
			default:
				fatalError()
			}
		}
	}

	enum ThemeSection: Int {
		case AutoTheme = 0
		case DefaultTheme
		case NightTheme

		//swiftlint:disable variable_name
		//swiftlint:disable type_name
		case COUNT_USE_ONLY_DO_NOT_USE
		static var numberOfRow: Int {
			return ThemeSection.COUNT_USE_ONLY_DO_NOT_USE.rawValue
		}
		//swiftlint:enable variable_name
		//swiftlint:enable type_name

		static var headerText: String {
			return NSLocalizedString("Theme", comment: "")
		}

		static var footerText: String {
			return NSLocalizedString(
				"The theme will automatically change based on your display brightness",
				comment: "")
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

	var settings = NSUserDefaults.standardUserDefaults()

	override func updateThemeInterface(theme: Theme, animated: Bool) {
		func updateInterface() {
			navigationController?.configureTheme(theme)
		}

		if animated {
			UIView.animateWithDuration(themeTransitionDuration, animations: updateInterface)
		} else {
			updateInterface()
		}
	}

}

extension SettingsTableViewController {

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return Section.count
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let sectionEnum = Section(rawValue: section) else {
			fatalError()
		}
		switch sectionEnum {
		case .General:
			return sectionEnum.numberOfRow
		case .Theme:
			return numberOFRowInThemeSection()
		default:
			fatalError()
		}
	}

	override func tableView(
		tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
			switch indexPath.section {
			case Section.General.rawValue:
				return cellForGeneralSectionAtRow(indexPath.row)
			case Section.Theme.rawValue:
				return cellForThemeSectionAtRow(indexPath.row)
			default:
				fatalError()
			}
	}

	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let sectionEnum = Section(rawValue: section) else {
			fatalError()
		}
		return sectionEnum.headerText
	}

	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		guard let sectionEnum = Section(rawValue: section) else {
			fatalError()
		}
		if sectionEnum == .Theme {
			return footerTitleForThemeSection()
		}
		return sectionEnum.footerText
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		guard let sectionEnum = Section(rawValue: indexPath.section) else {
			fatalError()
		}
		switch sectionEnum {
		case .Theme:
			didSelectThemeSectionCell(indexPath)
		default:
			return
		}
	}

}


// MARK: Helper
extension SettingsTableViewController {

	func dequeueSettingSwitchCell() -> SettingSwitchTableViewCell {
		guard let cell = tableView.dequeueReusableCellWithIdentifier(
			SettingSwitchTableViewCell.reusableIdentifier)
			as? SettingSwitchTableViewCell else {
				fatalError()
		}
		return cell
	}

	func dequeueSettingCheckableCell() -> SettingCheckableTableViewCell {
		guard let cell = tableView.dequeueReusableCellWithIdentifier(
			SettingCheckableTableViewCell.reusableIdentifier)
			as? SettingCheckableTableViewCell else {
				fatalError()
		}
		return cell
	}

}
