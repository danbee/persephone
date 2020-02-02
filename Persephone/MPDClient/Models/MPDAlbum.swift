//
//  Album.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/09.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension MPDClient {
  struct MPDAlbum: Equatable {
    let title: String
    let artist: String
    var firstSong: MPDSong?
    var date: String?

    static func == (lhs: MPDAlbum, rhs: MPDAlbum) -> Bool {
      return lhs.title == rhs.title &&
        lhs.artist == rhs.artist
    }
  }
}
