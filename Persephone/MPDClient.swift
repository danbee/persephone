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
  var delegate: MPDClientDelegate?
  static let stateChanged = Notification.Name("MPDClientStateChanged")
  static let queueChanged = Notification.Name("MPDClientQueueChanged")

  static let stateKey = "state"

  let HOST = "localhost"
  let PORT: UInt32 = 6600

  private var connection: OpaquePointer?
  private var status: OpaquePointer?

  private let commandQueue = DispatchQueue(label: "commandQueue")
  private var commandQueued = false

  enum Command {
    case prevTrack, nextTrack, playPause, stop, fetchStatus
  }

  enum State: UInt32 {
    case unknown = 0
    case stopped = 1
    case playing = 2
    case paused = 3
  }

  init(withDelegate delegate: MPDClientDelegate?) {
    print(delegate)
    self.delegate = delegate
  }

  func connect() {
    guard let connection = mpd_connection_new(HOST, PORT, 0)
      else { return }

    guard let status = mpd_run_status(connection)
      else { return }

    self.connection = connection
    self.status = status
    idle()
  }

  func disconnect() {
    mpd_status_free(status)
    mpd_connection_free(connection)
  }

  func fetchStatus() {
    sendCommand(command: .fetchStatus)
  }

  func getState() -> State {
    let state = mpd_status_get_state(status)
    return State(rawValue: state.rawValue)!
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

  func queueCommand(command: Command) {
    commandQueued = true
    noIdle()
    commandQueue.async { [unowned self] in
      self.sendCommand(command: command)
      self.commandQueued = false
    }
    idle()
  }

  func sendCommand(command: Command) {
    switch command {

    // Transport commands
    case .prevTrack:
      sendPreviousTrack()
    case .nextTrack:
      sendNextTrack()
    case .stop:
      sendStop()
    case .playPause:
      sendPlay()

    case .fetchStatus:
      guard let status = mpd_run_status(connection) else { break }
      self.status = status
    }
  }

  func sendNextTrack() {
    if [.playing, .paused].contains(getState()) {
      mpd_run_next(connection)
    }
  }

  func sendPreviousTrack() {
    if [.playing, .paused].contains(getState()) {
      mpd_run_previous(connection)
    }
  }

  func sendStop() {
    mpd_run_stop(connection)
  }

  func sendPlay() {
    if getState() == .stopped {
      mpd_run_play(connection)
    } else {
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

      if !self.commandQueued {
        self.fetchStatus()
        self.delegate?.didUpdateState(mpdClient: self, state: self.getState())
        self.idle()
      }
    }
  }

  func getLastErrorMessage() -> String! {
    if mpd_connection_get_error(connection) == MPD_ERROR_SUCCESS {
      return "no error"
    }

    if let errorMessage = mpd_connection_get_error_message(connection) {
      return String(cString: errorMessage)
    }

    return "no error"
  }
}
