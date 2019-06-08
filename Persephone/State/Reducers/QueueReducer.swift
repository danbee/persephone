//
//  QueueReducer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/21.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import ReSwift

func queueReducer(action: Action, state: QueueState?) -> QueueState {
  var state = state ?? QueueState()

  switch action {
  case let action as UpdateQueueAction:
    if state.queuePos >= action.queue.count {
      state.queuePos = -1
    }

    state.queue = action.queue.enumerated().map { index, mpdSong in
      let song = Song(mpdSong: mpdSong)

      return QueueItem(
        song: song,
        queuePos: index,
        isPlaying: index == state.queuePos
      )
    }

  case let action as UpdateQueuePosAction:
    let oldSongRowPos = state.queuePos
    let newSongRowPos = action.queuePos
    state.queuePos = action.queuePos

    if oldSongRowPos >= 0 {
      state.queue[oldSongRowPos].isPlaying = false
    }
    if newSongRowPos >= 0 {
      state.queue[newSongRowPos].isPlaying = true

      DispatchQueue.main.async {
        App.store.dispatch(
          UpdateCurrentSongAction(currentSong: state.queue[newSongRowPos].song)
        )
      }
    } else {
      DispatchQueue.main.async {
        App.store.dispatch(
          UpdateCurrentSongAction(currentSong: nil)
        )
      }
    }

  case let action as UpdateQueuePlayerStateAction:
    state.state = action.state
    
  default:
    break
  }

  return state
}
