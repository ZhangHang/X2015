//
//  AppDelegate+WatchApp.swift
//  X2015
//
//  Created by Hang Zhang on 2/23/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit
import WatchConnectivity
import X2015Kit

extension AppDelegate {

	func configureWatchSessionIfNeeded() {
		if !WCSession.isSupported() {
			return
		}
		session = WCSession.defaultSession()
	}

}

extension AppDelegate: WCSessionDelegate {

	func session(
		session: WCSession,
		didReceiveMessage message: [String : AnyObject],
		replyHandler: ([String : AnyObject]) -> Void) {
			guard let requestType = message[WatchConnectivityRequest.reqeustTypeKey] as? String else {
				debugPrint("Unhandled request \(message)")
				return
			}

			switch requestType {
			case WatchConnectivityRequest.GetNoteRequest.name:
				replyHandler([WatchConnectivityRequest.GetNoteRequest.replyKey: recentSimpleNotes()])
			case WatchConnectivityRequest.NewNoteRequest.name:
				guard let content = message[WatchConnectivityRequest.NewNoteRequest.infoKey] as? [AnyObject] else {
					fatalError()
				}
				createNote("\(content)")
			default:
				fatalError("Unhandled request")
			}
	}

	private func recentSimpleNotes() -> [[String: String]] {
		let fetchRequest = NSFetchRequest(entityName: Note.entityName)
		fetchRequest.fetchLimit = 10
		do {
			guard let notes = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Note] else {
				fatalError()
			}
			return notes.map({ (note) -> [String: String] in
				return SimpleNote(
					identifier: note.identifier,
					title: note.title ?? "",
					preview: note.preview ?? "")
					.toDictionary()
			})
		} catch {
			fatalError()
		}
	}

	private func createNote(contentFromWatch: String) {
		managedObjectContext.performChanges { [unowned self] () -> () in
			let newNote: Note = self.managedObjectContext.insertObject()
			newNote.update(contentFromWatch)
		}
	}

}
