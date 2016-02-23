//
//  InterfaceController.swift
//  X2015 Watch Extension
//
//  Created by Hang Zhang on 2/23/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

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

		// Configure interface objects here.

	}

	override func willActivate() {
		// This method is called when watch view controller is about to be visible to user

		super.willActivate()
	}

	override func didAppear() {
		super.didAppear()
		configure()
	}

	override func didDeactivate() {
		// This method is called when watch view controller is no longer visible
		super.didDeactivate()
	}

	override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
		debugPrint("Did Tap\(rowIndex)")
	}

	@IBAction func didPressedAddNoteButton() {
		presentTextInputControllerWithSuggestions(nil, allowedInputMode: .Plain) { (results) -> Void in
			debugPrint(results)
		}
	}
}

extension InterfaceController {

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

}

extension InterfaceController: WCSessionDelegate {

	func configure() {
		if !WCSession.isSupported() {
			return
		}

		session = WCSession.defaultSession()

		session?.sendMessage(
			[WatchConnectivityRequest.reqeustTypeKey: WatchConnectivityRequest.GetNoteRequest.name],
			replyHandler: { (response) -> Void in
				guard
					let notes = response[WatchConnectivityRequest.GetNoteRequest.replyKey] as? [[String: String]]? else {
						fatalError()
				}
				self.didReceiveRecentSimpleNotes(notes)
			}, errorHandler: { (error) -> Void in
				debugPrint("error \(error)")
		})

	}

	func didReceiveRecentSimpleNotes(simpleNoteDictionaries: [[String: String]]?) {
		guard let dictionaries = simpleNoteDictionaries else {
			self.notes = [SimpleNote]()
			reloadNoteTable()
			return
		}

		var notes = [SimpleNote]()
		for item in dictionaries {
			notes.append(SimpleNote.fromDictionary(item))
		}
		self.notes = notes
		reloadNoteTable()
	}

}

final class NoteTableRowController: NSObject {

	@IBOutlet weak var titleLabel: WKInterfaceLabel!
	@IBOutlet weak var previewLabel: WKInterfaceLabel!

	static let identifier = "NoteTableRowController"

}
