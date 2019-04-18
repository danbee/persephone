//
//  QueueDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class QueueDataSource: NSObject, NSOutlineViewDataSource {
  var queue: [QueueItem] = []
  var queuePos: Int = -1
  var currentSong: Song?

  var queueIcon: NSImage? = nil

  func updateQueue(_ queue: [MPDClient.MPDSong]) {
    queuePos = -1
    
    self.queue = queue.enumerated().map { index, mpdSong in
      let song = Song(mpdSong: mpdSong)
      return QueueItem(
        song: song,
        queuePos: index,
        isPlaying: index == queuePos
      )
    }
  }

  func setQueuePos(_ queuePos: Int) {
    let oldSongRowPos = self.queuePos
    let newSongRowPos = queuePos
    self.queuePos = queuePos

    if oldSongRowPos >= 0 {
      queue[oldSongRowPos].isPlaying = false
    }
    if newSongRowPos >= 0 {
      queue[newSongRowPos].isPlaying = true
      currentSong = queue[newSongRowPos].song
    } else {
      currentSong = nil
    }
  }

  func setQueueIcon(_ state: MPDClient.MPDStatus.State) {
    switch state {
    case .playing:
      queueIcon = .playIcon
    case .paused:
      queueIcon = .pauseIcon
    default:
      queueIcon = nil
    }
  }

  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    return queue.count + 1
  }

  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return false
  }

  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if index > 0 {
      return queue[index - 1]
    } else {
      return false
    }
  }
}
