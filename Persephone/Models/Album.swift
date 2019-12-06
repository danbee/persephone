//
//  AlbumItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/26.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import CryptoSwift

struct Album {
  var mpdAlbum: MPDClient.MPDAlbum

  init(mpdAlbum: MPDClient.MPDAlbum) {
    self.mpdAlbum = mpdAlbum
  }

  var title: String {
    return mpdAlbum.title
  }

  var artist: String {
    return mpdAlbum.artist
  }

  var date: String {
    guard let date = mpdAlbum.date else { return "" }
    return date
  }

  var hash: String {
    return "\(title) - \(artist)".sha1()
  }

  var coverArtFilenames: [String] {
    return [
      "cover.jpg",
      "folder.jpg",
      "\(artist) - \(title ).jpg",
      "cover.png",
      "folder.png",
      "\(artist) - \(title ).png",
    ]
  }

  var coverArtFilePath: String? {
    let musicDir = App.store.state.preferencesState.expandedMpdLibraryDir
    guard let albumPath = mpdAlbum.path else { return nil }

    return coverArtFilenames
      .lazy
      .map { "\(musicDir)/\(albumPath)/\($0)" }
      .first {
        FileManager.default.fileExists(atPath: $0)
      }
  }
}

extension Album: Equatable {
  static func == (lhs: Album, rhs: Album) -> Bool {
    return (lhs.mpdAlbum == rhs.mpdAlbum)
  }
}
