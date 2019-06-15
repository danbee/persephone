//
//  QueueDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

let REORDER_PASTEBOARD_TYPE = NSPasteboard.PasteboardType("me.danbarber.persephone")

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
      return ""
    }
  }

  func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
    guard let queueItem = item as? QueueItem
      else { return nil }

    let pasteboardItem = NSPasteboardItem()

    pasteboardItem.setPropertyList(["queuePos": queueItem.queuePos], forType: REORDER_PASTEBOARD_TYPE)

    return pasteboardItem
  }

  func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
    var newQueuePos = index - 1

    guard let draggingTypes = info.draggingPasteboard.types,
      draggingTypes.contains(REORDER_PASTEBOARD_TYPE),
      let payload = info.draggingPasteboard.propertyList(forType: REORDER_PASTEBOARD_TYPE) as? [String: Int],
      let queuePos = payload["queuePos"],
      newQueuePos >= 0
      else { return [] }

    if newQueuePos > queuePos { newQueuePos -= 1 }

    guard queuePos != newQueuePos
      else { return [] }

    return .move
  }

  func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
    var newQueuePos = index - 1

    guard let payload = info.draggingPasteboard.propertyList(forType: REORDER_PASTEBOARD_TYPE) as? [String: Int],
      let queuePos = payload["queuePos"]
      else { return false }

    if newQueuePos > queuePos { newQueuePos -= 1 }

    guard queuePos != newQueuePos
      else { return false }

    App.store.dispatch(MPDMoveSongInQueue(oldQueuePos: queuePos, newQueuePos: newQueuePos))

    return true
  }
}
