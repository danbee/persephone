//
//  AlbumListState.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

struct AlbumListState: StateType {
  var albums: [Album] = []
  var albumsWithUpdates: [Int]
}

extension AlbumListState: Equatable {
  static func == (lhs: AlbumListState, rhs: AlbumListState) -> Bool {
    return lhs.albums == rhs.albums
  }
}
