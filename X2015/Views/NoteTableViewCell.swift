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

	func configure(note: Note) {
		textLabel!.text = note.title
		detailTextLabel!.text = note.preview
	}

}
