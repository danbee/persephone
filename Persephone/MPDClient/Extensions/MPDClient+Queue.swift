//
//  Queue.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func fetchQueue() {
    sendCommand(command: .fetchQueue)
  }

  func playTrack(at queuePos: Int) {
    enqueueCommand(command: .playTrack, userData: ["queuePos": queuePos])
  }

  func appendSong(_ song: MPDSong) {
    enqueueCommand(command: .appendSong, userData: ["song": song])
  }

  func sendPlayTrack(at queuePos: Int) {
    mpd_run_play_pos(self.connection, UInt32(queuePos))
  }

  func sendFetchQueue() {
    self.queue = []
    mpd_send_list_queue_meta(connection)

    while let mpdSong = mpd_recv_song(connection) {
      let song = MPDSong(mpdSong)
      self.queue.append(song)
    }
  }

  func sendReplaceQueue(_ songs: [MPDSong]) {
    mpd_run_clear(self.connection)
    
    for song in songs {
      mpd_run_add(self.connection, song.uri)
    }
    mpd_run_play_pos(self.connection, 0)
  }

  func sendAppendSong(_ song: MPDSong) {
    mpd_run_add(self.connection, song.uri)
  }
}
