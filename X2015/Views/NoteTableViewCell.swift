//
//  NoteTableViewCell.swift
//  X2015
//
//  Created by Hang Zhang on 1/21/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class NoteTableViewCell: UITableViewCell, ConfigureableCell {

	static var reuseIdentifier: String! {
		return "NoteTableViewCell"
	}

	static var nibName: String {
		return "NoteTableViewCell"
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		NSNotificationCenter
			.defaultCenter()
			.addObserverForName(
				themeChangeNotification,
				object: nil,
				queue: NSOperationQueue.mainQueue()) { [unowned self] (_) -> Void in
					self.updateThemeInterface()
		}
	}

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

	func configure(note: Note) {
		textLabel!.text = note.title
		detailTextLabel!.text = note.preview

		updateThemeInterface()
	}

}

extension NoteTableViewCell: AppearanceAdaptable {

	static func configureThemeAppearance(theme: Theme) {
		switch theme {
		case .Bright:
			NoteTableViewCell.appearance().backgroundColor = UIColor.clearColor()
		case .Dark:
			NoteTableViewCell.appearance().backgroundColor = UIColor.clearColor()
		}
	}

}

extension NoteTableViewCell: ThemeAdaptable {}
