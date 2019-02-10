//
//  Album.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/09.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension MPDClient {
  class Album {
    let title: String
    let artist: String

    init(title: String, artist: String) {
      self.title = title
      self.artist = artist
    }
  }
}
