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

  var state: MPDClient.MPDStatus.State?

  var totalTime: UInt?
  var elapsedTimeMs: UInt?
}
