//
//  PlaylistState.swift
//  Persephone
//
//  Created by Dan Barber on 2020-4-24.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import ReSwift

struct PlaylistState: StateType, Equatable {
  var playlists: [Playlist] = []
}
