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
