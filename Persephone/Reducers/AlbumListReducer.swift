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

  case let action as UpdateAlbumArt:
    state.albums[action.albumIndex].coverArt = .loaded(action.coverArt)

  case is ResetAlbumListArt:
    state.albums = AppDelegate.store.state.albumListState.albums.map {
      var album = $0
      switch album.coverArt {
      case .loaded(let coverArt):
        if coverArt == nil {
          album.coverArt = .notLoaded
        }
      default:
        album.coverArt = .notLoaded
      }
      return album
    }

  default:
    break

  }

  return state
}
