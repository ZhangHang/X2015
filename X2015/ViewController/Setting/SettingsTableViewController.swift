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
	static var visible: Bool { get }

}

extension TableViewSection {

	static var numberOfRow: Int {
		return 0
	}

	static var headerText: String? {
		return nil
	}

	static var footerText: String? {
		return nil
	}

	var title: String {
		return ""
	}

	static var visible: Bool {
		return true
	}

}

final class SettingsTableViewController: ThemeAdaptableTableViewController {

	let defaultSections: [TableViewSection.Type] = [GeneralSection.self, ThemeSection.self, WatchSecion.self]
	var computedSecions: [TableViewSection.Type] = [TableViewSection.Type]()

	override func viewDidLoad() {
		updateComputedSecions()
	}

	func updateComputedSecions () {
		computedSecions.removeAll()
		for sectionType in defaultSections where sectionType.visible {
			computedSecions.append(sectionType)
		}
	}

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

	func indexOfSection(sectionType: TableViewSection.Type) -> Int? {
		return  computedSecions.indexOf({ (type) -> Bool in
			return String(type.dynamicType) == String(sectionType.dynamicType)
		})
	}

}

extension SettingsTableViewController {

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return computedSecions.count
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return computedSecions[section].numberOfRow
	}

	override func tableView(
		tableView: UITableView,
		cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
			switch String(computedSecions[indexPath.section].dynamicType) {
			case "GeneralSection.Type":
				return cellForGeneralSectionAtRow(indexPath.row)
			case "ThemeSection.Type":
				return cellForThemeSectionAtRow(indexPath.row)
			case "WatchSecion.Type":
				return cellForWatchSectionAtRow(indexPath.row)
			default:
				fatalError()
			}
	}

	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return computedSecions[section].headerText
	}

	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return computedSecions[section].footerText
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		switch String(computedSecions[indexPath.section].dynamicType) {
		case "GeneralSection.Type":
			return
		case "ThemeSection.Type":
			didSelectThemeSectionCell(indexPath)
		case "WatchSecion.Type":
			return
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
