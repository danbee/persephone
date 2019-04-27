//
//  AlbumItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/26.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import CryptoSwift

struct Album {
  var mpdAlbum: MPDClient.MPDAlbum
  var coverArt: Loading<NSImage?> = .notAsked

  init(mpdAlbum: MPDClient.MPDAlbum) {
    self.mpdAlbum = mpdAlbum
  }

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

extension Album: Equatable {
  static func == (lhs: Album, rhs: Album) -> Bool {
    return (lhs.artist == rhs.artist) &&
      (lhs.title == rhs.title) &&
      (lhs.coverArt ~= rhs.coverArt)
  }
}
