//
//  CGSize.swift
//  Persephone
//
//  Created by Daniel Barber on 1/20/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit

extension CGSize {
  static let albumListWidth = (UIScreen.main.bounds.width - 60) / 2
  static let albumDetailWidth = UIScreen.main.bounds.width - 40
  
  static let queueSongCoverSize = CGSize(width: 32, height: 32)
  static let albumListCoverSize = CGSize(width: albumListWidth, height: albumListWidth)
  static let albumDetailCoverSize = CGSize(width: albumDetailWidth, height: albumDetailWidth)
  static let currentlyPlayingCoverSize = albumDetailCoverSize
  static let notificationCoverSize = albumListCoverSize
}
