//
//  Playlist.swift
//  Persephone
//
//  Created by Dan Barber on 2020-4-25.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

struct Playlist {
  var mpdPlaylist: MPDClient.MPDPlaylist
  
  init(mpdPlaylist: MPDClient.MPDPlaylist) {
    self.mpdPlaylist = mpdPlaylist
  }
  
  var path: String {
    return mpdPlaylist.pathString
  }
}

extension Playlist: Equatable {
  static func == (lhs: Playlist, rhs: Playlist) -> Bool {
    return lhs.path == rhs.path
  }
}
