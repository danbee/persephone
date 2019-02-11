//
//  AlbumItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumItem: NSCollectionViewItem {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }

  func setAlbum(_ album: MPDClient.Album) {
    albumTitle.stringValue = album.title
    albumArtist.stringValue = album.artist
  }

  @IBOutlet var albumTitle: NSTextField!
  @IBOutlet var albumArtist: NSTextField!
}
