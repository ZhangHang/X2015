//
//  Note+Search.swift
//  X2015
//
//  Created by Hang Zhang on 2/1/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices

extension Note {

	func updateSearchIndex() {
		let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypePlainText as String)
		attributeSet.title = title
		attributeSet.contentDescription = body

		searchIndex = CSSearchableItem(uniqueIdentifier: identifier,
			domainIdentifier: "me.zhanghang.x2015.note",
			attributeSet: attributeSet)

		CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([searchIndex!]) { [unowned self] error in
			if error != nil {
				print(error?.localizedDescription)
			} else {
				print("Note with title \"\(self.title)\" indexed.")
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
			if error != nil {
				print(error?.localizedDescription)
			} else {
				print("\(self) indexed.")
			}
		}
	}

}