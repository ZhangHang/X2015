//
//  NoteManager.swift
//  X2015
//
//  Created by Hang Zhang on 1/26/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import X2015Kit

final class NoteManager {

	let noteObjectID: NSManagedObjectID
	let managedObjectContext: NSManagedObjectContext

	private(set) var note: Note?
	private(set) var currentTitle: String?
	private(set) var isCurrentNoteEmpty: Bool = false

	var titleDidChange: (() -> Void)?
	var emptyStatusDidChange: (() -> Void)?

	init?(noteObjectID: NSManagedObjectID, managedObjectContext: NSManagedObjectContext) {
		self.noteObjectID = noteObjectID
		self.managedObjectContext = managedObjectContext

		guard let note = managedObjectContext.objectWithID(noteObjectID)
			as? Note else {
				return nil
		}
		self.note = note
		update()
	}

	deinit {
		managedObjectContext.saveOrRollback()
	}

}

extension NoteManager {

	var noteContent: String? {
		return note!.content
	}

}

extension NoteManager {

	private var isNoteEmpty: Bool {
		return note?.content?.empty == true
	}

	func updateNote(content: String) {
		if note!.hasChange(content) {
			note!.update(content)
			update()
		}
	}

	func update() {
		if isCurrentNoteEmpty != (note?.content?.empty == true) {
			isCurrentNoteEmpty = !isCurrentNoteEmpty
			emptyStatusDidChange?()
		}
		if note!.title != currentTitle {
			currentTitle = note!.title
			titleDidChange?()
		}
	}

}
