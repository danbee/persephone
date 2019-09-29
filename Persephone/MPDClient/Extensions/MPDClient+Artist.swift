//
//  MPDClient+Artist.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/9/29.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func fetchAllArtists() {
    enqueueCommand(command: .fetchAllArtists)
  }

  func allArtists() {
    var artists: [String] = []

    mpd_search_db_tags(self.connection, MPD_TAG_ALBUM_ARTIST)
    mpd_search_commit(self.connection)

    while let pair = mpd_recv_pair(self.connection) {
      let pair = MPDPair(pair)

      switch pair.name {
      case "AlbumArtist":
        artists.append(pair.value)
      default:
        break
      }

      mpd_return_pair(self.connection, pair.pair)
    }

    self.delegate?.didLoadArtists(mpdClient: self, artists: artists)
  }
}
