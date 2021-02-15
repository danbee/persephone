//
//  AlbumSongItem.swift
//  Persephone-iOS
//
//  Created by Daniel Barber on 2020-3-30.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import Foundation

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
