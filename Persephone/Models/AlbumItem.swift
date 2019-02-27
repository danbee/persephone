//
//  AlbumItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/26.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

struct AlbumItem {
  var album: MPDClient.Album
  var coverArt: NSImage?

  var title: String {
    return album.title
  }

  var artist: String {
    return album.artist
  }
}
