//
//  PlayerReducer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import ReSwift

func playerReducer(action: Action, state: PlayerState?) -> PlayerState {
  var state = state ?? PlayerState()

  switch action {
  case let action as UpdateStatusAction:
    state.status = action.status
    state.state = action.status.state
    state.totalTime = action.status.totalTime
    state.elapsedTimeMs = action.status.elapsedTimeMs
    state.shuffleState = action.status.shuffleState
    state.repeatState = action.status.repeatState

    if state.state == .playing {
      App.trackTimer.start(elapsedTimeMs: state.elapsedTimeMs)
    } else {
      App.trackTimer.stop(elapsedTimeMs: state.elapsedTimeMs)
    }

    DispatchQueue.main.async {
      App.store.dispatch(
        UpdateQueuePlayerStateAction(state: state.state)
      )
      if let queuePos = state.status?.song {
        App.store.dispatch(UpdateQueuePosAction(queuePos: queuePos))
      }
    }

  case let action as UpdateCurrentSongAction:
    state.currentSong = action.currentSong

  case let action as UpdateElapsedTimeAction:
    state.elapsedTimeMs = action.elapsedTimeMs

  default:
    break
  }

  return state
}
