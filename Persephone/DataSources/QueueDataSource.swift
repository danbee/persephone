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
  var queueIcon: NSImage? = nil

  func setQueueIcon(_ state: QueueState) {
    switch state.state {
    case .playing?:
      queueIcon = .playIcon
    case .paused?:
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
