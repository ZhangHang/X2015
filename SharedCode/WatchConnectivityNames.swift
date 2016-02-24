//
//  WatchConnectivityNames.swift
//  X2015
//
//  Created by Hang Zhang on 2/23/16.
//  Copyright © 2016 Zhang Hang. All rights reserved.
//

import Foundation

struct WatchConnectivityRequest {

	static let reqeustTypeKey = "ReqeustType"

	struct GetNoteRequest {
		static let name = "GetNotes"
		static let replyKey = "GetNotesReplyKey"
	}

	struct NewNoteRequest {
		static let name = "NewNote"
		static let infoKey = "NewNoteInfoKey"
	}

	struct ReadNoteRequest {
		static let name = "ReadNote"
		static let infoKey = "ReadNoteInfoKey"
	}

}
