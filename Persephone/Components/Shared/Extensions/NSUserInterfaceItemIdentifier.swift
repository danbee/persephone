//
//  NSUserInterfaceItemIdentifier.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

extension NSUserInterfaceItemIdentifier {
  static let queueSongTitleColumn = NSUserInterfaceItemIdentifier("songTitleColumn")
  static let queueSongArtistColumn = NSUserInterfaceItemIdentifier("songArtistColumn")

  static let queueHeading = NSUserInterfaceItemIdentifier("queueHeadingCell")
  static let queueSongArtist = NSUserInterfaceItemIdentifier("songArtistCell")
  static let queueSongTitle = NSUserInterfaceItemIdentifier("songTitleCell")

  static let albumViewItem = NSUserInterfaceItemIdentifier("AlbumViewItem")
  static let artistViewItem = NSUserInterfaceItemIdentifier("ArtistViewItem")

  static let discNumber = NSUserInterfaceItemIdentifier("discNumberCell")
  static let trackNumber = NSUserInterfaceItemIdentifier("trackNumberCell")
  static let songTitle = NSUserInterfaceItemIdentifier("songTitleCell")
  static let songDuration = NSUserInterfaceItemIdentifier("songDurationCell")

  static let artistListName = NSUserInterfaceItemIdentifier("artistCell")
}
