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

  case let action as UpdateElapsedTimeAction:
    state.elapsedTimeMs = action.elapsedTimeMs

  case is StartedDatabaseUpdate:
    state.databaseUpdating = true

  case is FinishedDatabaseUpdate:
    state.databaseUpdating = false

  default:
    break
  }

  return state
}

func updateElapsedTime(_ timer: Timer) {
  guard let userInfo = timer.userInfo as? Dictionary<String, Any>,
    let elapsedTimeMs = userInfo["elapsedTimeMs"] as? UInt
    else { return }

  AppDelegate.store.dispatch(
    UpdateElapsedTimeAction(elapsedTimeMs: elapsedTimeMs)
  )
}
