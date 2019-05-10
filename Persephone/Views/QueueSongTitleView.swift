//
//  QueueSongTitleView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/10.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class QueueSongTitleView: NSTableCellView {
  @IBOutlet var queuePlayerStateImage: NSImageView!
  @IBOutlet var queuePosition: NSTextField!
  @IBOutlet var queueSongTitle: NSTextField!

  func setQueueSong(_ queueItem: QueueItem, queueIcon: NSImage?) {
    queuePosition?.font = .timerFont
    queueSongTitle?.stringValue = queueItem.song.title

    if queueItem.isPlaying {
      queueSongTitle?.font = .systemFontBold
      queuePlayerStateImage?.image = queueIcon
      queuePosition?.stringValue = ""
    } else {
      queueSongTitle?.font = .systemFontRegular
      queuePlayerStateImage?.image = nil
      queuePosition?.stringValue = "\(queueItem.queuePos + 1)."
    }
  }
}
