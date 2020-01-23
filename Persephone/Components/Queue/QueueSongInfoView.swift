//
//  QueueSongTitleView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/10.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class QueueSongInfoView: NSTableCellView {
  @IBOutlet var queueSongTitle: NSTextField!
  @IBOutlet var queueSongArtist: NSTextField!
  
  func setSong(_ queueItem: QueueItem, queueIcon: NSImage?) {
    queueSongTitle?.stringValue = queueItem.song.title
    queueSongArtist?.stringValue = queueItem.song.artist

    if queueItem.isPlaying && queueIcon != nil {
      queueSongTitle?.font = .systemFontBold
    } else {
      queueSongTitle?.font = .systemFontRegular
    }
  }
}
