//
//  AlbumTracksDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class AlbumTracksDataSource: NSObject, NSTableViewDataSource {
  struct AlbumSongItem {
    let disc: String?
    let song: Song?

    init(song: Song) {
      self.disc = nil
      self.song = song
    }

    init(disc: String) {
      self.disc = disc
      self.song = nil
    }
  }

  var albumSongs: [AlbumSongItem] = []

  func setAlbumSongs(_ songs: [Song]) {
    var disc: String? = ""

    songs.forEach { song in
      if song.disc != disc {
        disc = song.disc
        albumSongs.append(AlbumSongItem(disc: song.disc))
      }

      albumSongs.append(AlbumSongItem(song: song))
    }
  }

  func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
    let albumSongItem = albumSongs[row]

    guard let song = albumSongItem.song
      else { return nil }

    return NSPasteboardItem(
      draggedSong: DraggedSong(
        type: .albumSongItem(song.mpdSong.uriString),
        title: song.title,
        artist: song.artist
      ),
      ofType: .songPasteboardType
    )
  }

  func numberOfRows(in tableView: NSTableView) -> Int {
    return albumSongs.count
  }

  func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {
    session.enumerateDraggingItems(
      options: [],
      for: tableView,
      classes: [NSPasteboardItem.self],
      searchOptions: [:]
    ) { draggingItem, index, stop in
      guard let item = draggingItem.item as? NSPasteboardItem,
        let draggedSong = item.draggedSong(forType: .songPasteboardType),
        case let (title?, artist?) = (draggedSong.title, draggedSong.artist)
        else { return }

      draggingItem.imageComponentsProvider = {
        let component = NSDraggingImageComponent(key: NSDraggingItem.ImageComponentKey.icon)
        let draggedSongView = DraggedSongView(title: title, artist: artist)

        component.contents = draggedSongView.view.image()
        component.frame = NSRect(origin: CGPoint(), size: draggedSongView.view.image().size)
        return [component]
      }
    }
  }
}
