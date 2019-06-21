//
//  QueueDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

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

    let draggedSong = DraggedSong(
      type: .queueItem(queueItem.queuePos),
      title: queueItem.song.title,
      artist: queueItem.song.artist
    )

    let encoder = PropertyListEncoder()
    let data = try! encoder.encode(draggedSong)

    pasteboardItem.setData(data, forType: .songPasteboardType)

    return pasteboardItem
  }

  func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
    var newQueuePos = index - 1

    guard newQueuePos >= 0,
      let draggingTypes = info.draggingPasteboard.types,
      draggingTypes.contains(.songPasteboardType),
      let data = info.draggingPasteboard.data(forType: .songPasteboardType),
      let draggedSong = try? PropertyListDecoder().decode(DraggedSong.self, from: data)
      else { return [] }

    switch draggedSong.type {
    case let .queueItem(queuePos):
      if newQueuePos > queuePos { newQueuePos -= 1 }

      guard queuePos != newQueuePos
        else { return [] }

      return .move
    case .albumSongItem:
      return .copy
    }
  }

  func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
    var newQueuePos = index - 1

    guard let draggingTypes = info.draggingPasteboard.types,
      draggingTypes.contains(.songPasteboardType),
      let data = info.draggingPasteboard.data(forType: .songPasteboardType),
      let draggedSong = try? PropertyListDecoder().decode(DraggedSong.self, from: data)
      else { return false }

    switch draggedSong.type {
    case let .queueItem(queuePos):
      if newQueuePos > queuePos { newQueuePos -= 1 }

      guard queuePos != newQueuePos
        else { return false }

      App.store.dispatch(MPDMoveSongInQueue(oldQueuePos: queuePos, newQueuePos: newQueuePos))
      return true
    case let .albumSongItem(uri):
      App.store.dispatch(MPDAddSongToQueue(songUri: uri, queuePos: newQueuePos))
      return true
    }
  }

  func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
    session.enumerateDraggingItems(
      options: [],
      for: outlineView,
      classes: [NSPasteboardItem.self],
      searchOptions: [:]
    ) { draggingItem, index, stop in
      guard let item = draggingItem.item as? NSPasteboardItem,
        let data = item.data(forType: .songPasteboardType),
        let draggedSong = try? PropertyListDecoder().decode(DraggedSong.self, from: data),
        case let (title?, artist?) = (draggedSong.title, draggedSong.artist)
        else { return }

      draggingItem.imageComponentsProvider = {
        let component = NSDraggingImageComponent(key: NSDraggingItem.ImageComponentKey.icon)
        let draggedSongView = DraggedSongView(title: title, artist: artist)

        let view = draggedSongView.view
        let image = view.image()
        component.contents = image
        component.frame = NSRect(origin: CGPoint(), size: view.frame.size)
        return [component]
      }
    }
  }

}
