//
//  SongItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/25.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

struct Song {
  var mpdSong: MPDClient.MPDSong

  var trackNumber: String {
    return mpdSong.getTag(.track)
  }

  var title: String {
    return mpdSong.getTag(.title)
  }

  var artist: String {
    return mpdSong.getTag(.artist)
  }

  var album: Album {
    return Album(mpdAlbum: mpdSong.album)
  }
}

extension Song: Equatable {
  static func == (lhs: Song, rhs: Song) -> Bool {
    return (lhs.title == rhs.title) &&
      (lhs.artist == rhs.artist) &&
      (lhs.album == rhs.album)
  }
}
