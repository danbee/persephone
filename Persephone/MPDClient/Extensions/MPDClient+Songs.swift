//
//  MPDClient+Songs.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/7/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func searchSongs(_ terms: [MPDClient.MPDTag: String]) -> [MPDSong] {
    var songs: [MPDSong] = []

    mpd_search_db_songs(self.connection, true)
    for (tag, term) in terms {
      mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, tag.mpdTag(), term)
    }
    mpd_search_commit(self.connection)

    while let song = mpd_recv_song(self.connection) {
      songs.append(MPDSong(song))
    }

    return songs
  }
}
