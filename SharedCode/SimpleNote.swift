//
//  SimpleNote.swift
//  X2015
//
//  Created by Hang Zhang on 2/23/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

public struct SimpleNote {

	let identifier: String
	let title: String
	let preview: String

	public func toDictionary() -> [String: String] {
		return [
			"identifier": identifier,
			"title": title ?? "",
			"preview": preview ?? ""
		]
	}

	public static func fromDictionary(dictionary: [String: String]) -> SimpleNote {
		guard
			let identifier = dictionary["identifier"],
			let title = dictionary["title"],
			let preview = dictionary["preview"] else {
				fatalError()
		}

		return SimpleNote(identifier: identifier, title: title, preview: preview)
	}

}
