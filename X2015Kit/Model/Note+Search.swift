//
//  Note+Search.swift
//  X2015
//
//  Created by Hang Zhang on 2/1/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices

//swiftlint:disable variable_name
private let DomainIdentifier = "domainIdentifier"
//swiftlint:enable variable_name

extension Note {

	func updateSearchIndex() {
		let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypePlainText as String)
		attributeSet.title = title
		attributeSet.contentDescription = body

		searchIndex = CSSearchableItem(uniqueIdentifier: identifier,
			domainIdentifier: DomainIdentifier,
			attributeSet: attributeSet)

		CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([searchIndex!]) { error in
			if let error = error {
				debugPrint("index error: \(error.localizedDescription)")
			}
		}
	}

	func deleteSearchIndex() {
		guard let index = searchIndex else {
			debugPrint("No search index found")
			return
		}

		CSSearchableIndex
			.defaultSearchableIndex()
			.deleteSearchableItemsWithIdentifiers([index.uniqueIdentifier]) { (error) -> Void in
				if let error = error {
					debugPrint("index delete error: \(error.localizedDescription)")
				}
		}
	}

}
