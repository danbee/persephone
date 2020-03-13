//
//  NSSize.swift
//  Persephone
//
//  Created by Daniel Barber on 1/20/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import AppKit

extension NSSize {
  static let queueSongCoverSize = NSSize(width: 32, height: 32)
  static let albumListCoverSize = NSSize(width: 180, height: 180)
  static let albumDetailCoverSize = NSSize(width: 500, height: 500)
  static let currentlyPlayingCoverSize = albumDetailCoverSize
  static let notificationCoverSize = albumListCoverSize
}
