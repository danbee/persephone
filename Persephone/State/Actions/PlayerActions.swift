//
//  PlayerActions.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import ReSwift

struct UpdateCurrentSongAction: Action {
  var currentSong: Song?
}

struct UpdateElapsedTimeAction: Action {
  var elapsedTimeMs: UInt = 0
}

struct UpdateStatusAction: Action {
  var status: MPDClient.MPDStatus
}

struct UpdateVolumeAction: Action {
  var volume: Int
}
