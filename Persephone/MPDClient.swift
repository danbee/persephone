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
  static let queuePosChanged = Notification.Name("MPDClientQueuePosChanged")

  static let stateKey = "state"
  static let queueKey = "queue"
  static let queuePosKey = "song"

  let HOST = "localhost"
  let PORT: UInt32 = 6600

  private var connection: OpaquePointer?
  var status: Status?
  private var queue: [Song] = []

  private let commandQueue = DispatchQueue(label: "commandQueue")

  enum Command {
    case prevTrack, nextTrack, playPause, stop, fetchStatus, fetchQueue
  }

  enum State: UInt32 {
    case unknown = 0
    case stopped = 1
    case playing = 2
    case paused = 3
  }

  struct Idle: OptionSet {
    let rawValue: UInt32

    static let database = Idle(rawValue: 0x1)
    static let storedPlaylist = Idle(rawValue: 0x2)
    static let queue = Idle(rawValue: 0x4)
    static let player = Idle(rawValue: 0x8)
    static let mixer = Idle(rawValue: 0x10)
    static let output = Idle(rawValue: 0x20)
    static let options = Idle(rawValue: 0x40)
    static let update = Idle(rawValue: 0x80)
    static let sticker = Idle(rawValue: 0x100)
    static let subscription = Idle(rawValue: 0x200)
    static let message = Idle(rawValue: 0x400)
  }

  init(withDelegate delegate: MPDClientDelegate?) {
    self.delegate = delegate
  }

  func connect() {
    guard let connection = mpd_connection_new(HOST, PORT, 0)
      else { return }

    guard let status = mpd_run_status(connection)
      else { return }

    self.connection = connection
    self.status = Status(status)

    fetchQueue()

    self.delegate?.didUpdateState(mpdClient: self, state: self.status!.state())
    self.delegate?.didUpdateQueue(mpdClient: self, queue: self.queue)
    idle()
  }

  func disconnect() {
    noIdle()
    commandQueue.async { [unowned self] in
      mpd_connection_free(self.connection)
    }
  }

  func fetchStatus() {
    sendCommand(command: .fetchStatus)
  }

  func fetchQueue() {
    sendCommand(command: .fetchQueue)
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
    noIdle()
    commandQueue.async { [unowned self] in
      self.sendCommand(command: command)
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
      self.status = Status(status)

    case .fetchQueue:
      self.queue = []
      mpd_send_list_queue_meta(connection)

      while let mpdSong = mpd_recv_song(connection) {
        let song = Song(mpdSong)
        self.queue.append(song)
      }
    }
  }

  func sendNextTrack() {
    if [MPD_STATE_PLAY, MPD_STATE_PAUSE].contains(status?.state()) {
      mpd_run_next(connection)
    }
  }

  func sendPreviousTrack() {
    if [MPD_STATE_PLAY, MPD_STATE_PAUSE].contains(status?.state()) {
      mpd_run_previous(connection)
    }
  }

  func sendStop() {
    mpd_run_stop(connection)
  }

  func sendPlay() {
    if status?.state() == MPD_STATE_STOP {
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
      let result = mpd_recv_idle(self.connection, true)

      self.handleIdleResult(result)
    }
  }

  func handleIdleResult(_ result: mpd_idle) {
    let mpdIdle = Idle(rawValue: result.rawValue)

    if mpdIdle.contains(.queue) {
      self.fetchQueue()
      self.delegate?.didUpdateQueue(mpdClient: self, queue: self.queue)
    }
    if mpdIdle.contains(.player) {
      self.fetchStatus()
      self.delegate?.didUpdateState(mpdClient: self, state: self.status!.state())
    }
    if !mpdIdle.isEmpty {
      self.idle()
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
