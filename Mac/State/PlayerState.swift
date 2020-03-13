//
//  PlayerState.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

struct PlayerState: StateType {
  var status: MPDClient.MPDStatus?
  var currentSong: Song?

  var state: MPDClient.MPDStatus.State?
  var shuffleState: Bool = false
  var repeatState: Bool = false
  
  var volume: Int = 0

  var totalTime: UInt?
  var elapsedTimeMs: UInt?
}

extension PlayerState: Equatable {
  static func == (lhs: PlayerState, rhs: PlayerState) -> Bool {
    return lhs.state == rhs.state &&
      lhs.totalTime == rhs.totalTime &&
      lhs.elapsedTimeMs == rhs.elapsedTimeMs &&
      lhs.shuffleState == rhs.shuffleState &&
      lhs.repeatState == rhs.repeatState &&
      lhs.volume == rhs.volume
  }
}
