//
//  AlbumListReducer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/21.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

func albumListReducer(action: Action, state: AlbumListState?) -> AlbumListState {
  var state = state ?? AlbumListState()

  switch action {
  case let action as UpdateAlbumListAction:
    state.albums = action.albums.map { Album(mpdAlbum: $0) }
  default:
    break
  }

  return state
}
