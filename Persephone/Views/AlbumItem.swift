//
//  AlbumItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumItem: NSCollectionViewItem {
  let albumCoverBorderColor = NSColor.init(calibratedWhite: 1, alpha: 0.1)

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.

    albumCoverView.wantsLayer = true
    albumCoverView.layer?.cornerRadius = 3
    albumCoverView.layer?.borderWidth = 1
    albumCoverView.layer?.borderColor = albumCoverBorderColor.cgColor
  }

  func setAlbum(_ album: MPDClient.Album) {
    albumTitle.stringValue = album.title
    albumArtist.stringValue = album.artist
  }

  @IBOutlet var albumCoverView: NSImageView!
  @IBOutlet var albumTitle: NSTextField!
  @IBOutlet var albumArtist: NSTextField!
}
