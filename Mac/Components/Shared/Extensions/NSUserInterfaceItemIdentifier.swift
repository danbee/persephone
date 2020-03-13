//
//  NSUserInterfaceItemIdentifier.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

extension NSUserInterfaceItemIdentifier {
  static let queueSongInfoColumn = NSUserInterfaceItemIdentifier("songInfoColumn")

  static let queueSongCover = NSUserInterfaceItemIdentifier("songCoverCell")
  static let queueSongInfo = NSUserInterfaceItemIdentifier("songInfoCell")
  static let queueSongDuration = NSUserInterfaceItemIdentifier("songDurationCell")

  static let albumViewItem = NSUserInterfaceItemIdentifier("AlbumViewItem")

  static let discNumber = NSUserInterfaceItemIdentifier("discNumberCell")
  static let trackNumber = NSUserInterfaceItemIdentifier("trackNumberCell")
  static let songTitle = NSUserInterfaceItemIdentifier("songTitleCell")
  static let songDuration = NSUserInterfaceItemIdentifier("songDurationCell")

  static let artistListName = NSUserInterfaceItemIdentifier("artistCell")
}
