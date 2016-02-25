//
//  NoteTableInterfaceController.swift
//  X2015 Watch Extension
//
//  Created by Hang Zhang on 2/23/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class NoteTableInterfaceController: WKInterfaceController {

	@IBOutlet var table: WKInterfaceTable!
	var notes: [SimpleNote] = [SimpleNote]()

	var session: WCSession? {
		didSet {
			if let session = session {
				session.delegate = self
				session.activateSession()
			}
		}
	}

	override func awakeWithContext(context: AnyObject?) {
		super.awakeWithContext(context)

		if !WCSession.isSupported() {
			return
		}

		session = WCSession.defaultSession()
		updateNotesFromApplicationContext()
	}

	override func willActivate() {
		reloadNoteTable()
		super.willActivate()
	}

	override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
		session?.sendMessage([
			WatchConnectivityRequest.reqeustTypeKey: WatchConnectivityRequest.ReadNoteRequest.name,
			WatchConnectivityRequest.ReadNoteRequest.infoKey: notes[rowIndex].identifier],
			replyHandler: nil,
			errorHandler: nil)
	}

	@IBAction func didPressedAddNoteButton() {
		presentTextInputControllerWithSuggestions(
			nil,
			allowedInputMode: .Plain) { [unowned self] (results) -> Void in
				guard let results = results else {
					return
				}
				self.sendNewNoteContentToApplicationContext(results)
		}
	}

}

extension NoteTableInterfaceController {

	func updateNotesFromApplicationContext() {
		let notesDictionary = session?.receivedApplicationContext[WatchConnectivityRequest.GetNoteRequest.replyKey]
		guard let notes = notesDictionary as? [[String: String]] else {
			self.notes = [SimpleNote]()
			return
		}

		self.notes.removeAll()
		for item in notes {
			self.notes.append(SimpleNote.fromDictionary(item))
		}
	}

	func reloadNoteTable() {
		self.table.setNumberOfRows(notes.count, withRowType: NoteTableRowController.identifier)

		for i in 0 ..< notes.count {
			guard let controller = self.table.rowControllerAtIndex(i) as? NoteTableRowController else {
				fatalError()
			}
			controller.titleLabel.setText("\(notes[i].title)")
			controller.previewLabel.setText("\(notes[i].preview)")
		}
	}

	func sendNewNoteContentToApplicationContext(content: [AnyObject]) {
		_ = try? session?.updateApplicationContext([WatchConnectivityRequest.NewNoteRequest.infoKey: content])
	}

}

extension NoteTableInterfaceController: WCSessionDelegate {

	func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
		debugPrint("received \(applicationContext)")
		updateNotesFromApplicationContext()
		reloadNoteTable()
	}

}

final class NoteTableRowController: NSObject {

	@IBOutlet weak var titleLabel: WKInterfaceLabel!
	@IBOutlet weak var previewLabel: WKInterfaceLabel!

	static let identifier = "NoteTableRowController"

}
