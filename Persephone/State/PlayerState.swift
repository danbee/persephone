//
//  PlayerState.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import ReSwift

struct PlayerState: StateType {
  var status: MPDClient.MPDStatus?
  var currentSong: Song?
  var currentArtwork: NSImage?

  var state: MPDClient.MPDStatus.State?

  var totalTime: UInt?
  var elapsedTimeMs: UInt?

  var databaseUpdating: Bool = false
}

extension PlayerState: Equatable {
  static func == (lhs: PlayerState, rhs: PlayerState) -> Bool {
    return (lhs.state == rhs.state) &&
      (lhs.totalTime == rhs.totalTime) &&
      (lhs.elapsedTimeMs == rhs.elapsedTimeMs) &&
      (lhs.databaseUpdating == rhs.databaseUpdating)
  }
}
