//
//  NoteReaderControllerToolBar.swift
//  X2015
//
//  Created by Hang Zhang on 2/20/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

private let playOrPauseButtonIndex = 4
private let playButtonDefaultIndex = 4
private let pauseButtonDefaultIndex = 5

final class NoteReaderControllerToolBar: UIToolbar {

	/// Store play & pause button with strong reference
	/// So we could add / remove them at runtime
	@IBOutlet var pauseButton: UIBarButtonItem!
	@IBOutlet var playButton: UIBarButtonItem!

	@IBOutlet weak var rewindButton: UIBarButtonItem!
	@IBOutlet weak var fastforwardButton: UIBarButtonItem!
	@IBOutlet weak var stopButton: UIBarButtonItem!
	@IBOutlet weak var speedButton: UIBarButtonItem!

	private var hasInited = false

	var isPlaying: Bool = true {
		didSet {
			if !hasInited {
				items!.removeAtIndex(playOrPauseButtonIndex)
				hasInited = true
			}
			items!.removeAtIndex(playOrPauseButtonIndex)
			if isPlaying {
				items!.insert(pauseButton, atIndex: playOrPauseButtonIndex)
			} else {
				items!.insert(playButton, atIndex: playOrPauseButtonIndex)
			}

			rewindButton.enabled = isPlaying
			fastforwardButton.enabled = isPlaying
			speedButton.enabled = isPlaying
		}
	}


	var didPressedPlayButton: ((view: NoteReaderControllerToolBar) -> Void)?
	var didPressedPauseButton: ((view: NoteReaderControllerToolBar) -> Void)?
	var didPressedStopButton: ((view: NoteReaderControllerToolBar) -> Void)?
	var didPressedFastForwardButton: ((view: NoteReaderControllerToolBar) -> Void)?
	var didPressedRewindButton: ((view: NoteReaderControllerToolBar) -> Void)?
	var didPressedSpeedButton: ((view: NoteReaderControllerToolBar) -> Void)?

}

// MARK: Actions
extension NoteReaderControllerToolBar {

	@IBAction
	func handlePlayButtonPressed(sender: UIBarButtonItem) {
		didPressedPlayButton?(view: self)
	}

	@IBAction
	func handlePauseButtonPressed(sender: UIBarButtonItem) {
		didPressedPauseButton?(view: self)
	}

	@IBAction
	func handleStopButtonPressed(sender: UIBarButtonItem) {
		didPressedStopButton?(view: self)
	}

	@IBAction
	func handleFastForwardButtonPressed(sender: UIBarButtonItem) {
		didPressedFastForwardButton?(view: self)
	}

	@IBAction
	func handleRewindButtonPressed(sender: UIBarButtonItem) {
		didPressedRewindButton?(view: self)
	}

	@IBAction
	func handleSpeedButtonPressed(sender: UIBarButtonItem) {
		didPressedSpeedButton?(view: self)
	}

}

extension NoteReaderControllerToolBar: NibLoadable {}
