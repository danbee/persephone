//
//  NSPasteboardItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

extension NSPasteboardItem {
  convenience init(draggedSong: DraggedSong, ofType type: NSPasteboard.PasteboardType) {
    self.init()
    self.setDraggedSong(draggedSong, forType: type)
  }

  convenience init(draggedAlbum: DraggedAlbum, ofType type: NSPasteboard.PasteboardType) {
    self.init()
    self.setDraggedAlbum(draggedAlbum, forType: type)
  }

  func setDraggedSong(_ draggedSong: DraggedSong, forType type: NSPasteboard.PasteboardType) {
    let data = try! PropertyListEncoder().encode(draggedSong)

    setData(data, forType: type)
  }

  func setDraggedAlbum(_ draggedAlbum: DraggedAlbum, forType type: NSPasteboard.PasteboardType) {
    let data = try! PropertyListEncoder().encode(draggedAlbum)

    setData(data, forType: type)
  }

  func draggedSong(forType type: NSPasteboard.PasteboardType) -> DraggedSong? {
    guard let itemData = data(forType: type)
      else { return nil }

    return try? PropertyListDecoder().decode(DraggedSong.self, from: itemData)
  }
}
