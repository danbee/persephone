//
//  MPDClient.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/1/25.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

class MPDClient {
  let HOST = "localhost"
  let PORT: UInt32 = 6600

  private let connection: OpaquePointer
  private var status: OpaquePointer?

  private let commandQueue = DispatchQueue(label: "commandQueue")
  private var commandQueued = false

  enum TransportCommand {
    case prevTrack, nextTrack, playPause, stop
  }

  init?() {
    guard let connection = mpd_connection_new(HOST, PORT, 0)
      else { return nil }

    guard let status = mpd_run_status(connection)
      else { return nil }

    self.connection = connection
    self.status = status
  }

  deinit {
    mpd_status_free(status)
    mpd_connection_free(connection)
  }

  func fetchStatus() {
    status = mpd_run_status(connection)
    idle()
  }

  func getState() {
    print(mpd_status_get_state(status))
    idle()
  }

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

  func queueCommand(command: TransportCommand) {
    commandQueued = true
    noIdle()
    commandQueue.async { [unowned self] in
      self.sendCommand(command: command)
      self.commandQueued = false
    }
    idle()
  }

  func sendCommand(command: TransportCommand) {
    switch command {
    case .prevTrack:
      mpd_run_previous(connection)
    case .nextTrack:
      mpd_run_next(connection)
    case .stop:
      mpd_run_stop(connection)
    case .playPause:
      mpd_run_toggle_pause(connection)
    }
  }

  func noIdle() {
    mpd_send_noidle(connection)
  }

  func idle() {
    commandQueue.async { [unowned self] in
      mpd_send_idle(self.connection)
      mpd_recv_idle(self.connection, true)

      if !self.commandQueued { self.idle() }
    }
  }

  func getLastErrorMessage() -> String! {
    if mpd_connection_get_error(connection) == MPD_ERROR_SUCCESS {
      return "no error"
    }

    if let errorMessage = mpd_connection_get_error_message(connection) {
      return String(cString: errorMessage)
    }

    return "no error message"
  }
}
