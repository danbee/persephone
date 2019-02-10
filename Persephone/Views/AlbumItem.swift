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

  func setAlbumTitle(_ title: String) {
    albumTitle.stringValue = title
  }

  func setAlbumArtist(_ artist: String) {
    albumArtist.stringValue = artist
  }

  @IBOutlet var albumTitle: NSTextField!
  @IBOutlet var albumArtist: NSTextField!
}
