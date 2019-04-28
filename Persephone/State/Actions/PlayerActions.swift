//
//  PlayerActions.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import ReSwift

struct UpdateCurrentCoverArt: Action {
  var coverArt: NSImage?
}

struct UpdateCurrentSong: Action {
  var currentSong: Song
}

struct UpdateElapsedTimeAction: Action {
  var elapsedTimeMs: UInt = 0
}

struct UpdateStatusAction: Action {
  var status: MPDClient.MPDStatus
}

struct StartedDatabaseUpdate: Action {}

struct FinishedDatabaseUpdate: Action {}
