//
//  PlayerReducer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Dispatch
import ReSwift

func playerReducer(action: Action, state: PlayerState?) -> PlayerState {
  var state = state ?? PlayerState()

  switch action {
  case is ResetStatusAction:
    state.state = .unknown
    state.totalTime = 0
    state.elapsedTimeMs = 0
    state.shuffleState = false
    state.repeatState = false
    state.volume = -1

  case let action as UpdateStatusAction:
    state.status = action.status
    state.state = action.status.state
    state.totalTime = action.status.totalTime
    state.elapsedTimeMs = action.status.elapsedTimeMs
    state.shuffleState = action.status.shuffleState
    state.repeatState = action.status.repeatState
    state.volume = action.status.volume

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

    if let elapsedTimeMs = state.elapsedTimeMs,
      let totalTime = state.totalTime,
      elapsedTimeMs / 1000 > totalTime {
      App.mpdClient.enqueueCommand(command: .fetchStatus)
    }
    
  default:
    break
  }

  return state
}
