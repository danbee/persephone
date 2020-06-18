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
      queueIcon = .queuePlayIcon
    case .paused?:
      queueIcon = .queuePauseIcon
    default:
      queueIcon = nil
    }
  }

  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    return queue.count
  }

  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return false
  }

  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    return queue[index]
  }

  func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
    guard let queueItem = item as? QueueItem
      else { return nil }

    return NSPasteboardItem(
      draggedSong: DraggedSong(
        type: .queueItem(queueItem.queuePos),
        title: queueItem.song.title,
        artist: queueItem.song.artist,
        albumArtist: queueItem.song.albumArtist,
        album: queueItem.song.album.title,
        uri: queueItem.song.mpdSong.uriString
      ),
      ofType: .songPasteboardType
    )
  }

  func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
    var newQueuePos = index

    guard newQueuePos >= 0,
      let draggingTypes = info.draggingPasteboard.types
      else { return [] }

    if draggingTypes.contains(.songPasteboardType) {
      guard let pasteboardItem = info.draggingPasteboard.pasteboardItems?.first,
        let draggedSong = pasteboardItem.draggedSong(forType: .songPasteboardType)
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
    } else if draggingTypes.contains(.albumPasteboardType) {
      return .copy
    }

    return []
  }

  func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
    var newQueuePos = index

    guard let draggingTypes = info.draggingPasteboard.types
      else { return false }

    if draggingTypes.contains(.songPasteboardType) {
      guard let data = info.draggingPasteboard.data(forType: .songPasteboardType),
        let draggedSong = try? PropertyListDecoder().decode(DraggedSong.self, from: data)
        else { return false }

      switch draggedSong.type {
      case let .queueItem(queuePos):
        if newQueuePos > queuePos { newQueuePos -= 1 }

        guard queuePos != newQueuePos
          else { return false }

        App.mpdClient.moveSongInQueue(at: queuePos, to: newQueuePos)
        return true
      case let .albumSongItem(uri):
        App.mpdClient.addSongToQueue(songUri: uri, at: newQueuePos)
        return true
      }
    } else if draggingTypes.contains(.albumPasteboardType) {
      guard let data = info.draggingPasteboard.data(forType: .albumPasteboardType),
        let draggedAlbum = try? PropertyListDecoder().decode(DraggedAlbum.self, from: data)
        else { return false }

      let mpdAlbum = MPDClient.MPDAlbum(title: draggedAlbum.title, artist: draggedAlbum.artist)

      App.mpdClient.addAlbumToQueue(album: mpdAlbum, at: newQueuePos)
      return true
    }

    return false
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
        case let (title, artist, album, albumArtist, uri) = (
          draggedSong.title,
          draggedSong.artist,
          draggedSong.album,
          draggedSong.albumArtist,
          draggedSong.uri
        )
        else { return }

      draggingItem.imageComponentsProvider = {
        let component = NSDraggingImageComponent(key: NSDraggingItem.ImageComponentKey.icon)
        let draggedSongView = DraggedSongView(
          title: title,
          artist: artist,
          albumArtist: albumArtist,
          album: album,
          uri: uri
        )

        let view = draggedSongView.view
        let image = view.image()
        component.contents = image
        component.frame = NSRect(origin: CGPoint(), size: view.frame.size)
        return [component]
      }
    }
  }
}
