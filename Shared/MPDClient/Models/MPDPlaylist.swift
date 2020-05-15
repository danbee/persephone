//
//  MPDPlaylist.swift
//  Persephone
//
//  Created by Dan Barber on 2020-4-25.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import Foundation

extension MPDClient {
  class MPDPlaylist {
    let playlist: OpaquePointer
    
    init(_ playlist: OpaquePointer) {
      self.playlist = playlist
    }
    
    deinit {
      mpd_playlist_free(playlist)
    }
    
    var path: UnsafePointer<Int8> {
      return mpd_playlist_get_path(playlist)
    }
    
    var pathString: String {
      return String(cString: path)
    }
  }
}
