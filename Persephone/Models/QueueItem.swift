//
//  SongItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

struct QueueItem {
  var song: Song
  var queuePos: Int
  var isPlaying: Bool
}

extension QueueItem: Equatable {
  static func == (lhs: QueueItem, rhs: QueueItem) -> Bool {
    return (lhs.song == rhs.song) &&
      (lhs.queuePos == rhs.queuePos) &&
      (lhs.isPlaying == rhs.isPlaying)
  }
}
