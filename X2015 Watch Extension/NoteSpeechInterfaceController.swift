//
//  NoteSpeechInterfaceController.swift
//  X2015
//
//  Created by Hang Zhang on 2/24/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import WatchKit
import Foundation


class NoteSpeechInterfaceController: WKInterfaceController {

	@IBOutlet var titleLabel: WKInterfaceLabel!
	@IBOutlet var movie: WKInterfaceMovie!
	@IBOutlet var speedButton: WKInterfaceButton!


	struct Storyboard {
		static let identifier = "ShowNoteSpeech"
	}

	var note: SimpleNote!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
		guard let noteDictionary = context as? [String: String] else {
			fatalError()
		}
		note = SimpleNote.fromDictionary(noteDictionary)
        titleLabel.setText(note.title)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
		mov
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
