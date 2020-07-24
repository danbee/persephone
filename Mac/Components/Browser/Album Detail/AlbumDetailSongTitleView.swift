//
//  AlbumDetailSongTitleView.swift
//  Persephone
//
//  Created by Nemo157 on 20200619...
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import AppKit

class AlbumDetailSongTitleView: NSTableCellView {
  @IBOutlet var songTitle: NSTextField!
  @IBOutlet var songArtist: NSTextField!
  
  func setShowArtist(_ show: Bool) {
    songArtist.isHidden = !show
  }

  func setSong(_ song: Song) {
    songTitle?.stringValue = song.title
    songArtist?.stringValue = song.artist
  }
}

