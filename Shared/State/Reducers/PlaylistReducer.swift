//
//  PlaylistReducer.swift
//  Persephone
//
//  Created by Dan Barber on 2020-4-25.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import ReSwift

func playlistReducer(action: Action, state: PlaylistState?) -> PlaylistState {
  var state = state ?? PlaylistState()
  
  switch action {
  case let action as UpdatePlaylistsAction:
    state.playlists = action.playlists.map { Playlist(mpdPlaylist: $0) }
    
  default:
    break

  }
  
  return state
}
