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


class SettingsTableViewController: ThemeAdaptableTableViewController {


	private enum Section: Int {

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

	private enum GeneralSection: Int, TableViewSection {

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

	private enum ThemeSection: Int {

		case AutoTheme = 0
		case BrightTheme
		case DarkTheme

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
			case .BrightTheme:
				return NSLocalizedString("Default", comment: "")
			case .DarkTheme:
				return NSLocalizedString("Night", comment: "")
			default:
				fatalError()
			}
		}

	}

	private let settings = Settings()

	override func updateThemeInterface(theme: Theme, animated: Bool) {
		func updateInterface() {
			navigationController?.configureTheme(theme)
		}

		if animated {
			UIView.animateWithDuration(themeTransitionDuration, animations: { () -> Void in
		updateInterface()
			})
		} else {
			updateInterface()
		}
	}

	override func updateCellThemeInterface<CellType: UITableViewCell>(cell: CellType, theme: Theme) {}

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

// MARK: General

extension SettingsTableViewController {

	private func cellForGeneralSectionAtRow(row: Int) -> UITableViewCell {
		guard let cellType = GeneralSection(rawValue: row) else { fatalError() }

		func touchIDCell() -> SettingSwitchTableViewCell {
			let cell = dequeueSettingSwitchCell()
			cell.configure(
				NSLocalizedString("Touch ID", comment: ""),
				switchOn: settings.unlockByTouchID,
				switchTarget: self,
				switchSelector: "handleUnlockByTouchIDSwitchValueChanged:",
				enabled: TouchIDHelper.hasTouchID)
			return cell
		}

		switch cellType {
		case .UnlockByTouchID:
			return touchIDCell()
		default:
			fatalError()
		}
	}

	@objc
	private func handleUnlockByTouchIDSwitchValueChanged(sender: UISwitch) {
		TouchIDHelper.auth(
			NSLocalizedString("Use Touch ID to Unlock", comment: ""),
			successHandler: { () -> Void in
				self.settings.unlockByTouchID = sender.on
				guard self.settings.synchronize() else {
					fatalError("Setting save failed")
				}
			},
			errorHandler: { (errorMessage) -> Void in
				sender.setOn(!sender.on, animated: true)
				if errorMessage?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
					let alertView = UIAlertController(
						title: NSLocalizedString("Error", comment: ""),
						message: errorMessage,
						preferredStyle:.Alert)
					let okAction = UIAlertAction(
						title: NSLocalizedString("OK", comment: ""),
						style: .Default,
						handler: nil)
					alertView.addAction(okAction)
					self.presentViewController(alertView, animated: true, completion: nil)
				}
		})
	}

}


// MARK: Theme
extension SettingsTableViewController {

	private func cellForThemeSectionAtRow(row: Int) -> UITableViewCell {
		guard let cellType = ThemeSection(rawValue: row) else { fatalError() }

		func AutoThemeCell() -> UITableViewCell {
			let cell = dequeueSettingSwitchCell()
			cell.configure(
				ThemeSection.AutoTheme.title,
				switchOn: settings.automaticallyAdjustsTheme,
				switchTarget: self,
				switchSelector: "handleAutoThemeSwitchValueChanged:")
			return cell
		}
		func DefualtThemeCell() -> UITableViewCell {
			let cell = dequeueSettingCheckableCell()
			cell.configure(ThemeSection.BrightTheme.title, checked: settings.theme == .Defualt)
			return cell
		}
		func NightThemeCell() -> UITableViewCell {
			let cell = dequeueSettingCheckableCell()
			cell.configure(ThemeSection.DarkTheme.title, checked: settings.theme == .Night)
			return cell
		}

		switch cellType {
		case .AutoTheme:
			return AutoThemeCell()
		case .BrightTheme:
			return DefualtThemeCell()
		case .DarkTheme:
			return NightThemeCell()
		default:
			fatalError()
		}
	}

	private func numberOFRowInThemeSection() -> Int {
		if settings.automaticallyAdjustsTheme {
			return 1
		}
		return ThemeSection.numberOfRow
	}

	private func footerTitleForThemeSection() -> String? {
		if settings.automaticallyAdjustsTheme {
			return ThemeSection.footerText
		}
		return nil
	}

	private func didSelectThemeSectionCell(indexPath: NSIndexPath) {
		guard let cellType = ThemeSection(rawValue: indexPath.row) else { fatalError() }
		switch cellType {
		case .AutoTheme:
			return
		case .BrightTheme:
			settings.theme = .Defualt
		case .DarkTheme:
			settings.theme = .Night
		default:
			fatalError()
		}

		settings.synchronize()
		ThemeManager.sharedInstance.synchronizeWithSettings()
		tableView.reloadSections(NSIndexSet(index: Section.Theme.rawValue), withRowAnimation: .None)
	}

	@objc
	private func handleAutoThemeSwitchValueChanged(sender: UISwitch) {
		settings.automaticallyAdjustsTheme = sender.on
		settings.synchronize()
		ThemeManager.sharedInstance.synchronizeWithSettings()
		tableView.reloadSections(NSIndexSet(index: Section.Theme.rawValue), withRowAnimation: .Automatic)
	}

}

extension SettingsTableViewController {

	private func dequeueSettingSwitchCell() -> SettingSwitchTableViewCell {
		guard let cell = tableView.dequeueReusableCellWithIdentifier(
			SettingSwitchTableViewCell.reusableIdentifier)
			as? SettingSwitchTableViewCell else {
				fatalError()
		}
		return cell
	}

	private func dequeueSettingCheckableCell() -> SettingCheckableTableViewCell {
		guard let cell = tableView.dequeueReusableCellWithIdentifier(
			SettingCheckableTableViewCell.reusableIdentifier)
			as? SettingCheckableTableViewCell else {
				fatalError()
		}
		return cell
	}

}
