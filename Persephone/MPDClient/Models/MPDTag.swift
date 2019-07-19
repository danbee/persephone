//
//  MPDTag.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/7/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  enum MPDTag: Int {
    case unknown = -1
    case artist, album, albumArtist, title, track, name,
    genre, date, composer, performer, comment, disc

    case musicBrainzArtistId
    case musicBrainzAlbumId
    case musicBrainzAlbumArtistId
    case musicBrainzTrackId
    case musicBrainzReleaseTrackId

    case originalDate

    case artistSort
    case albumArtistSort
    case albumSort

    case tagCount

    func mpdTag() -> mpd_tag_type {
      return mpd_tag_type(rawValue: Int32(self.rawValue))
    }
  }
}
