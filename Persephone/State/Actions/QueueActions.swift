//
//  QueueActions.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

struct UpdateQueueAction: Action {
  var queue: [MPDClient.MPDSong]
}

struct UpdateQueuePosAction: Action {
  var queuePos: Int
}

struct UpdateQueuePlayerStateAction: Action {
  var state: MPDClient.MPDStatus.State?
}
