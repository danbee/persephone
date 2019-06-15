//
//  MPDReducer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/30.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

func mpdReducer(action: Action, state: MPDState?) -> MPDState {
  let state = state ?? MPDState()

  switch action {
  case is MPDConnectAction:
    let mpdServer = App.store.state.preferencesState.mpdServer
    App.mpdClient.connect(
      host: mpdServer.hostOrDefault,
      port: mpdServer.portOrDefault
    )
  case is MPDDisconnectAction:
    App.mpdClient.disconnect()

  case is MPDPlayPauseAction:
    App.mpdClient.playPause()
  case is MPDStopAction:
    App.mpdClient.stop()
  case is MPDNextTrackAction:
    App.mpdClient.nextTrack()
  case is MPDPrevTrackAction:
    App.mpdClient.prevTrack()

  case is MPDClearQueue:
    App.mpdClient.clearQueue()

  case let action as MPDMoveSongInQueue:
    App.mpdClient.moveSongInQueue(at: action.oldQueuePos, to: action.newQueuePos)

  case let action as MPDAppendTrack:
    App.mpdClient.appendSong(action.song)

  case let action as MPDRemoveTrack:
    App.mpdClient.removeSong(at: action.queuePos)

  case let action as MPDPlayTrack:
    App.mpdClient.playTrack(at: action.queuePos)

  case let action as MPDPlayAlbum:
    App.mpdClient.playAlbum(action.album)

  case let action as MPDSeekCurrentSong:
    App.mpdClient.seekCurrentSong(timeInSeconds: action.timeInSeconds)

  case let action as MPDSetShuffleAction:
    App.mpdClient.setShuffleState(shuffleState: action.shuffleState)

  case let action as MPDSetRepeatAction:
    App.mpdClient.setRepeatState(repeatState: action.repeatState)

  case is MPDUpdateDatabaseAction:
    App.mpdClient.updateDatabase()

  default:
    break
  }

  return state
}
