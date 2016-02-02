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

	func configure(note: Note) {
		textLabel!.text = note.title
		detailTextLabel!.text = note.preview
	}

}

extension NoteTableViewCell: ReusableCell {}

extension NoteTableViewCell: ThemeAdaptable {

	func configureTheme(theme: Theme) {
		backgroundColor = UIColor.clearColor()
		switch theme {
		case .Defualt:
			textLabel?.textColor = UIColor.defualt_MainTextColor()
			detailTextLabel?.textColor = UIColor.defualt_SubTextColor()
			selectionStyle = .Gray
			selectedBackgroundView = nil
		case .Night:
			selectionStyle = .Default
			textLabel?.textColor = UIColor.night_MainTextColor()
			detailTextLabel?.textColor = UIColor.night_SubTextColor()
			selectedBackgroundView = UIView()
			selectedBackgroundView!.backgroundColor = UIColor.night_tableViewCellBackgroundColor()
		}
	}

}
