//
//  Transport.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func playPause() {
    queueCommand(command: .playPause)
  }

  func stop() {
    queueCommand(command: .stop)
  }

  func prevTrack() {
    queueCommand(command: .prevTrack)
  }

  func nextTrack() {
    queueCommand(command: .nextTrack)
  }

  func seekCurrentSong(timeInSeconds: Float) {
    queueCommand(
      command: .seekCurrentSong,
      userData: ["timeInSeconds": timeInSeconds]
    )
  }

  func sendNextTrack() {
    guard let state = status?.state,
      state.isOneOf([.playing, .paused])
      else { return }

    mpd_run_next(connection)
  }

  func sendPreviousTrack() {
    guard let state = status?.state,
      state.isOneOf([.playing, .paused])
      else { return }

    mpd_run_previous(connection)
  }

  func sendStop() {
    mpd_run_stop(connection)
  }

  func sendPlay() {
    if status?.state == .stopped {
      mpd_run_play(connection)
    } else {
      mpd_run_toggle_pause(connection)
    }
  }

  func sendSeekCurrentSong(timeInSeconds: Float) {
    mpd_run_seek_current(self.connection, timeInSeconds, false)
  }
}
