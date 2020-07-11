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
  var collapseArtist: NSLayoutConstraint!
  
  func setShowArtist(_ show: Bool) {
    if collapseArtist == nil {
       collapseArtist = songArtist?.heightAnchor.constraint(equalToConstant: 0.0)
    }

    collapseArtist.isActive = !show
  }

  func setSong(_ song: Song) {
    songTitle?.stringValue = song.title
    songArtist?.stringValue = song.artist
  }
}

