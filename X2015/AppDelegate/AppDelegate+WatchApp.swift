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

		NSNotificationCenter
			.defaultCenter()
			.addObserverForName(
				NSManagedObjectContextDidSaveNotification,
				object: nil,
				queue: NSOperationQueue.mainQueue()) { (note) -> Void in
			self.sendRecentNotesToWatchApp()
		}
		sendRecentNotesToWatchApp()
	}

	func sendRecentNotesToWatchApp() {
		_ = try? session?.updateApplicationContext(
			[WatchConnectivityRequest.GetNoteRequest.replyKey: recentSimpleNotes()])
	}

}

extension AppDelegate: WCSessionDelegate {

	func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
		if let notes = applicationContext[WatchConnectivityRequest.NewNoteRequest.infoKey] as? [String] {
			createNote(notes.joinWithSeparator(" "))
		}
		debugPrint(applicationContext)
	}

	func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
		debugPrint(message)
		if let identifier = message[WatchConnectivityRequest.ReadNoteRequest.infoKey] as? String {
			guard let note = Note.fetchNote(identifier, managedObjectContext: managedObjectContext) else {
				return
			}
			NoteReaderController.sharedInstance.prepare(note.title ?? "", note: note.content ?? "")
			NoteReaderController.sharedInstance.startReading()
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



}
