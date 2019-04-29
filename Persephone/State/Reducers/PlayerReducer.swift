//
//  PlayerReducer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import ReSwift

func playerReducer(action: Action, state: PlayerState?) -> PlayerState {
  var state = state ?? PlayerState()

  switch action {
  case let action as UpdateStatusAction:
    state.status = action.status
    state.state = action.status.state
    state.totalTime = action.status.totalTime
    state.elapsedTimeMs = action.status.elapsedTimeMs

    if state.state == .playing {
      AppDelegate.trackTimer.start(elapsedTimeMs: state.elapsedTimeMs)
    } else {
      AppDelegate.trackTimer.stop(elapsedTimeMs: state.elapsedTimeMs)
    }

    DispatchQueue.main.async {
      AppDelegate.store.dispatch(
        UpdateQueuePlayerStateAction(state: state.state)
      )
    }

  case let action as UpdateCurrentSongAction:
    state.currentSong = action.currentSong

    if let currentSong = state.currentSong {
      let coverArtService = CoverArtService(song: currentSong)

      coverArtService.fetchBigCoverArt()
        .done() { image in
          DispatchQueue.main.async {
            if let image = image {
              AppDelegate.store.dispatch(UpdateCurrentCoverArtAction(coverArt: image))
            } else {
              AppDelegate.store.dispatch(UpdateCurrentCoverArtAction(coverArt: .defaultCoverArt))
            }
          }
        }
        .cauterize()
    } else {
      DispatchQueue.main.async {
        AppDelegate.store.dispatch(UpdateCurrentCoverArtAction(coverArt: .defaultCoverArt))
      }
    }

  case let action as UpdateCurrentCoverArtAction:
    state.currentArtwork = action.coverArt

  case let action as UpdateElapsedTimeAction:
    state.elapsedTimeMs = action.elapsedTimeMs

  case is StartedDatabaseUpdateAction:
    state.databaseUpdating = true

  case is FinishedDatabaseUpdateAction:
    state.databaseUpdating = false

  default:
    break
  }

  return state
}
