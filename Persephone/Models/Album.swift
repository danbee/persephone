//
//  AlbumItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/26.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

struct Album {
  var mpdAlbum: MPDClient.MPDAlbum
  var coverArt: NSImage?

  var title: String {
    return mpdAlbum.title
  }

  var artist: String {
    return mpdAlbum.artist
  }

  var hash: String {
    return "\(title) - \(artist)".sha1()
  }
}
