//
//  XWindow.swift
//  X2015
//
//  Created by Hang Zhang on 2/22/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import UIKit

final class XWindow: UIWindow {}


extension XWindow {

	override func remoteControlReceivedWithEvent(event: UIEvent?) {
		guard let receivedEvent = event where receivedEvent.type == UIEventType.RemoteControl else { return }

		let controller = NoteReaderController.sharedInstance

		debugPrint(receivedEvent.subtype)

		switch receivedEvent.subtype {
		case .RemoteControlPlay:
			if controller.speechSynthesizer.speaking {
				controller.speechSynthesizer.continueSpeaking()
			} else {
				controller.startReading()
			}
		case .RemoteControlPause:
			controller.speechSynthesizer.pauseSpeakingAtBoundary(.Immediate)
		case .RemoteControlStop:
			controller.speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
		case .RemoteControlTogglePlayPause:
			if controller.speechSynthesizer.paused {
				controller.speechSynthesizer.continueSpeaking()
			} else {
				controller.speechSynthesizer.pauseSpeakingAtBoundary(.Immediate)
			}
			break
		case .RemoteControlNextTrack:
			break
		case .RemoteControlPreviousTrack:
			break
		case .RemoteControlBeginSeekingBackward:
			break
		case .RemoteControlEndSeekingBackward:
			break
		case .RemoteControlBeginSeekingForward:
			break
		case .RemoteControlEndSeekingForward:
			break
		default:
			return
		}
	}

}
