//
//  MPDClientSong.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/03.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  class Song {
    let mpdSong: OpaquePointer

    init(_ mpdSong: OpaquePointer) {
      self.mpdSong = mpdSong
    }

    func free() {
      mpd_song_free(mpdSong)
    }

    func getTag(_ tagType: mpd_tag_type) -> String {
      guard let tag = mpd_song_get_tag(mpdSong, tagType, 0)
        else { return "" }
      
      return String(cString: tag)
    }
  }
}
