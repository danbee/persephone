//
//  ArtistReducer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/9/29.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

func artistListReducer(action: Action, state: ArtistListState?) -> ArtistListState {
  var state = state ?? ArtistListState()

  switch action {
  case let action as UpdateArtistListAction:
    state.artists = action.artists
    
  default:
    break
    
  }

  return state
}

