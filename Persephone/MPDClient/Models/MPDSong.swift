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
  class MPDSong {
    let song: OpaquePointer

    init(_ song: OpaquePointer) {
      self.song = song
    }

    deinit {
      mpd_song_free(song)
    }

    var uri: UnsafePointer<Int8> {
      return mpd_song_get_uri(song)
    }

    var uriString: String {
      return String(cString: uri)
    }

    var duration: Int {
      return Int(mpd_song_get_duration(song))
    }

    var album: MPDAlbum {
      return MPDAlbum(
        title: getTag(.album),
        artist: artist
      )
    }

    var artist: String {
      if getTag(.albumArtist) != "" {
        return getTag(.albumArtist)
      } else {
        return getTag(.artist)
      }
    }

    var date: String {
      return getTag(.date)
    }

    func getTag(_ tagType: MPDTag) -> String {
      guard let tag = mpd_song_get_tag(song, tagType.mpdTag(), 0)
        else { return "" }
      
      return String(cString: tag)
    }
  }
}
