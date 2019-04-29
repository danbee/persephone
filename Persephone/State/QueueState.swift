//
//  QueueState.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

struct QueueState: StateType {
  var queue: [QueueItem] = []
  var queuePos: Int = -1

  var state: MPDClient.MPDStatus.State?
}

extension QueueState: Equatable {
  static func == (lhs: QueueState, rhs: QueueState) -> Bool {
    return (lhs.queue == rhs.queue) &&
      (lhs.queuePos == rhs.queuePos) &&
      (lhs.state == rhs.state)
  }
}
