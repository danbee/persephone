//
//  QueueViewController+NSOutlineViewDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/14.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

extension QueueViewController: NSOutlineViewDelegate {
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    if let queueItem = item as? QueueItem {
      switch tableColumn?.identifier.rawValue {
        case "songCoverColumn":
          return cellForSongCover(outlineView, with: queueItem)
        case "songInfoColumn":
          return cellForSongInfo(outlineView, with: queueItem)
        case "songDurationColumn":
          return cellForSongDuration(outlineView, with: queueItem)
        default:
          return nil
      }
    } else {
      return nil
    }
  }

  func outlineViewSelectionDidChange(_ notification: Notification) {
    let queueItem = dataSource.queue[queueView.selectedRow]

    App.store.dispatch(SetSelectedQueueItem(selectedQueueItem: queueItem))
  }
  
  func cellForSongCover(_ outlineView: NSOutlineView, with queueItem: QueueItem) -> NSView {
      let cellView = outlineView.makeView(
      withIdentifier: .queueSongCover,
      owner: self
    ) as! QueueSongCoverView
    
    cellView.setSong(queueItem, queueIcon: dataSource.queueIcon)
    
    return cellView
  }

  func cellForSongInfo(_ outlineView: NSOutlineView, with queueItem: QueueItem) -> NSView {
    let cellView = outlineView.makeView(
      withIdentifier: .queueSongInfo,
      owner: self
    ) as! QueueSongInfoView

    cellView.setSong(queueItem, queueIcon: dataSource.queueIcon)

    return cellView
  }
  
  func cellForSongDuration(_ outlineView: NSOutlineView, with queueItem: QueueItem) -> NSView {
    let cellView = outlineView.makeView(
      withIdentifier: .queueSongDuration,
      owner: self
    ) as! NSTableCellView
    
    cellView.textField?.font = .timerFont
    cellView.textField?.stringValue = queueItem.song.duration.formattedTime

    return cellView
  }
}
