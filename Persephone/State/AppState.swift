//
//  AppState.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/18.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

struct AppState: StateType {
  var serverState = ServerState()
  var playerState = PlayerState()
  var queueState = QueueState()
  var albumListState = AlbumListState()
  var artistListState = ArtistListState()
  var preferencesState = PreferencesState()
  var uiState = UIState()
}
