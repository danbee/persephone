//
//  QueueViewController+NSOutlineViewDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/14.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

extension QueueViewController: NSOutlineViewDelegate {
  func outlineView(
    _ outlineView: NSOutlineView,
    selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet
    ) -> IndexSet {
    if proposedSelectionIndexes.contains(0) {
      return IndexSet()
    } else {
      return proposedSelectionIndexes
    }
  }

  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    if let queueItem = item as? QueueItem {
      switch tableColumn?.identifier.rawValue {
        case "songTitleColumn":
          return cellForSongTitle(outlineView, with: queueItem)
        case "songArtistColumn":
          return cellForSongArtist(outlineView, with: queueItem)
        default:
          return nil
      }
    } else if tableColumn?.identifier.rawValue == "songTitleColumn" {
      return cellForQueueHeading(outlineView)
    } else {
      return nil
    }
  }

  func outlineViewSelectionDidChange(_ notification: Notification) {
    if queueView.selectedRow >= 1 {
      let queueItem = dataSource.queue[queueView.selectedRow - 1]

      App.store.dispatch(SetSelectedQueueItem(selectedQueueItem: queueItem))
    } else {
      App.store.dispatch(SetSelectedQueueItem(selectedQueueItem: nil))
    }
  }

  func cellForSongTitle(_ outlineView: NSOutlineView, with queueItem: QueueItem) -> NSView {
    let cellView = outlineView.makeView(
      withIdentifier: .queueSongTitle,
      owner: self
      ) as! QueueSongTitleView

    cellView.setQueueSong(queueItem, queueIcon: dataSource.queueIcon)

    return cellView
  }

  func cellForSongArtist(_ outlineView: NSOutlineView, with queueItem: QueueItem) -> NSView {
    let cellView = outlineView.makeView(
      withIdentifier: .queueSongArtist,
      owner: self
      ) as! NSTableCellView

    cellView.textField?.stringValue = queueItem.song.artist
    if queueItem.isPlaying {
      cellView.textField?.font = .systemFontBold
    } else {
      cellView.textField?.font = .systemFontRegular
    }

    return cellView
  }

  func cellForQueueHeading(_ outlineView: NSOutlineView) -> NSView {
    let cellView = outlineView.makeView(
      withIdentifier: .queueHeading,
      owner: self
      ) as! NSTableCellView

    cellView.textField?.stringValue = "QUEUE"

    return cellView
  }
}
