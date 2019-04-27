//
//  QueueDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class QueueDataSource: NSObject, NSOutlineViewDataSource {
  var queueIcon: NSImage? = nil

  func setQueueIcon() {
    switch AppDelegate.store.state.playerState.state {
    case .playing?:
      queueIcon = .playIcon
    case .paused?:
      queueIcon = .pauseIcon
    default:
      queueIcon = nil
    }
  }

  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    return AppDelegate.store.state.queueState.queue.count + 1
  }

  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return false
  }

  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if index > 0 {
      return AppDelegate.store.state.queueState.queue[index - 1]
    } else {
      return false
    }
  }
}
