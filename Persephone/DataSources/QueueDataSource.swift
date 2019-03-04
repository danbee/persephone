//
//  QueueDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class QueueDataSource: NSObject, NSOutlineViewDataSource {
  var queue: [SongItem] = []
  var queuePos: Int = -1

  var queueIcon: NSImage? = nil

  let playIcon = NSImage(named: "playButton")
  let pauseIcon = NSImage(named: "pauseButton")

  func updateQueue(_ queue: [MPDClient.Song]) {
    queuePos = -1
    
    self.queue = queue.enumerated().map { index, song in
      SongItem(song: song, queuePos: index, isPlaying: index == queuePos)
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
    }
  }

  func setQueueIcon(_ state: MPDClient.Status.State) {
    switch state {
    case .playing:
      queueIcon = playIcon
    case .paused:
      queueIcon = pauseIcon
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
