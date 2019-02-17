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

  private var connection: OpaquePointer?
  private var isConnected: Bool = false
  private var status: Status?
  private var queue: [Song] = []

  private let commandQueue = DispatchQueue(label: "commandQueue")

  enum Command {
    case prevTrack, nextTrack, playPause, stop,
      fetchStatus, fetchQueue, fetchAllAlbums
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

  func connect(host: String, port: Int) {
    commandQueue.async { [unowned self] in
      guard let connection = mpd_connection_new(host, UInt32(port), 10000),
        mpd_connection_get_error(connection) == MPD_ERROR_SUCCESS
        else { return }

      self.isConnected = true

      guard let status = mpd_run_status(connection)
        else { return }

      self.connection = connection
      self.status = Status(status)

      self.fetchQueue()
      self.fetchAllAlbums()
      self.idle()

      self.delegate?.didConnect(mpdClient: self)
      self.delegate?.didUpdateState(mpdClient: self, state: self.status!.state)
      self.delegate?.didUpdateQueue(mpdClient: self, queue: self.queue)
      self.delegate?.didUpdateQueuePos(mpdClient: self, song: self.status!.song)
    }
  }

  func disconnect() {
    guard isConnected else { return }
    
    noIdle()
    commandQueue.async { [unowned self] in
      self.delegate?.willDisconnect(mpdClient: self)
      
      mpd_connection_free(self.connection)
      self.isConnected = false
    }
  }

  func fetchStatus() {
    sendCommand(command: .fetchStatus)
  }

  func fetchQueue() {
    sendCommand(command: .fetchQueue)
  }

  func fetchAllAlbums() {
    sendCommand(command: .fetchAllAlbums)
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

  func playTrack(queuePos: Int) {
    guard isConnected else { return }

    noIdle()
    commandQueue.async { [unowned self] in
      mpd_run_play_pos(self.connection, UInt32(queuePos))
    }
    idle()
  }

  func playAlbum(_ album: Album) {
    noIdle()
    commandQueue.async { [unowned self] in
      var songs: [Song] = []

      mpd_run_clear(self.connection)
      mpd_search_db_songs(self.connection, true)
      mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM, album.title)
      mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM_ARTIST, album.artist)
      mpd_search_commit(self.connection)
      while let mpdSong = mpd_recv_song(self.connection) {
        songs.append(Song(mpdSong))
      }
      for song in songs {
        mpd_run_add(self.connection, song.uri)
      }
      mpd_run_play_pos(self.connection, 0)
    }
    idle()
  }

  func queueCommand(command: Command) {
    guard isConnected else { return }
    
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
      sendRunStatus()
    case .fetchQueue:
      sendFetchQueue()
    case .fetchAllAlbums:
      allAlbums()
    }
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

  func sendRunStatus() {
    guard let status = mpd_run_status(connection) else { return }
    self.status = Status(status)
  }

  func sendFetchQueue() {
    self.queue = []
    mpd_send_list_queue_meta(connection)

    while let mpdSong = mpd_recv_song(connection) {
      let song = Song(mpdSong)
      self.queue.append(song)
    }
  }

  func allAlbums() {
    var albums: [Album] = []
    var artist: String = ""

    mpd_search_db_tags(connection, MPD_TAG_ALBUM)
    mpd_search_add_group_tag(connection, MPD_TAG_ALBUM_ARTIST)
    mpd_search_commit(connection)
    while let mpdPair = mpd_recv_pair(connection) {
      let pair = Pair(mpdPair)

      switch pair.name {
      case "AlbumArtist":
        artist = pair.value
      case "Album":
        albums.append(Album(title: pair.value, artist: artist))
      default:
        break
      }

      mpd_return_pair(connection, pair.mpdPair)
    }

    delegate?.didLoadAlbums(mpdClient: self, albums: albums)
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
      self.delegate?.didUpdateState(mpdClient: self, state: self.status!.state)
      self.delegate?.didUpdateQueuePos(mpdClient: self, song: self.status!.song)
    }
    if !mpdIdle.isEmpty {
      self.idle()
    }
  }

  func getLastErrorMessage() -> String? {
    if mpd_connection_get_error(connection) == MPD_ERROR_SUCCESS {
      return nil
    }

    if let errorMessage = mpd_connection_get_error_message(connection) {
      return String(cString: errorMessage)
    }

    return nil
  }
}
