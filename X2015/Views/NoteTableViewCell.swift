//
//  NoteTableViewCell.swift
//  X2015
//
//  Created by Hang Zhang on 1/21/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import X2015Kit

final class NoteTableViewCell: UITableViewCell {

	static var nibName: String {
		return "NoteTableViewCell"
	}

	static var defaultDateFormatter: NSDateFormatter = {
		let formatter = NSDateFormatter()
		formatter.dateStyle = .ShortStyle
		formatter.timeStyle = .ShortStyle
		formatter.doesRelativeDateFormatting = true
		return formatter
	}()

	var detailTextColor = UIColor.default_SubTextColor()
	private var modificationText = ""
	private var previewText = ""

	var detailAttributeText: NSAttributedString {
		let modificationDateTextColor = detailTextColor
		let previewTextColor = modificationDateTextColor.colorWithAlphaComponent(0.5)
		let detailAttributeText = NSMutableAttributedString()
		detailAttributeText.appendAttributedString(
			NSAttributedString(
				string: "\(modificationText)  ",
				attributes: [NSForegroundColorAttributeName: modificationDateTextColor])
		)
		detailAttributeText.appendAttributedString(
			NSAttributedString(
				string: previewText,
				attributes: [NSForegroundColorAttributeName: previewTextColor])
		)
		return detailAttributeText
	}

	func configure(note: Note) {
		textLabel!.text = note.title

		modificationText = "\(NoteTableViewCell.defaultDateFormatter.stringFromDate(note.updatedAt))  "
		previewText = note.preview ?? ""

		refreshDetailAttributeTextLabel()
	}

	func refreshDetailAttributeTextLabel() {
		detailTextLabel!.attributedText = detailAttributeText
	}

}

extension NoteTableViewCell: ReusableCell {}

extension NoteTableViewCell: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		backgroundColor = UIColor.clearColor()
		switch theme {
		case .Default:
			textLabel?.textColor = UIColor.default_MainTextColor()
			detailTextColor = UIColor.default_SubTextColor()
			refreshDetailAttributeTextLabel()
			selectionStyle = .Gray
			selectedBackgroundView = nil
		case .Night:
			selectionStyle = .Default
			textLabel?.textColor = UIColor.night_MainTextColor()
			detailTextColor = UIColor.night_SubTextColor()
			refreshDetailAttributeTextLabel()
			selectedBackgroundView = UIView()
			selectedBackgroundView!.backgroundColor = UIColor.night_tableViewCellBackgroundColor()
		}
	}

}
