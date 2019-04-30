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
  case let action as MPDConnectAction:
    App.mpdClient.connect(host: action.host, port: action.port)
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

  case let action as MPDPlayTrack:
    App.mpdClient.playTrack(at: action.queuePos)

  case let action as MPDPlayAlbum:
    App.mpdClient.playAlbum(action.album)

  case let action as MPDSeekCurrentSong:
    App.mpdClient.seekCurrentSong(timeInSeconds: action.timeInSeconds)

  case is MPDUpdateDatabaseAction:
    App.mpdClient.updateDatabase()

  default:
    break
  }

  return state
}
