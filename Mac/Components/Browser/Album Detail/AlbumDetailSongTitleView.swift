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
  
  func setSong(_ song: Song) {
    if collapseArtist == nil {
       collapseArtist = songArtist?.heightAnchor.constraint(equalToConstant: 0.0)
    }

    songTitle?.stringValue = song.title
    songArtist?.stringValue = song.artist
    collapseArtist.isActive = song.artist == song.albumArtist
  }
}

