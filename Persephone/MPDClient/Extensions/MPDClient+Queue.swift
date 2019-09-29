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
    enqueueCommand(command: .fetchQueue)
  }

  func clearQueue() {
    enqueueCommand(command: .clearQueue)
  }

  func playTrack(at queuePos: Int) {
    enqueueCommand(command: .playTrack, userData: ["queuePos": queuePos])
  }

  func appendSong(_ song: MPDSong) {
    enqueueCommand(command: .appendSong, userData: ["song": song])
  }

  func removeSong(at queuePos: Int) {
    enqueueCommand(command: .removeSong, userData: ["queuePos": queuePos])
  }

  func moveSongInQueue(at queuePos: Int, to newQueuePos: Int) {
    enqueueCommand(command: .moveSongInQueue, userData: ["oldQueuePos": queuePos, "newQueuePos": newQueuePos])
  }

  func addSongToQueue(songUri: String, at queuePos: Int) {
    enqueueCommand(command: .addSongToQueue, userData: ["uri": songUri, "queuePos": queuePos])
  }

  func addAlbumToQueue(album: MPDAlbum, at queuePos: Int) {
    enqueueCommand(command: .addAlbumToQueue, userData: ["album": album, "queuePos": queuePos])
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

    self.delegate?.didUpdateQueue(mpdClient: self, queue: self.queue)
  }

  func sendClearQueue() {
    mpd_run_clear(self.connection)
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

  func sendRemoveSong(at queuePos: Int) {
    mpd_run_delete(self.connection, UInt32(queuePos))
  }

  func sendMoveSongInQueue(at oldQueuePos: Int, to newQueuePos: Int) {
    mpd_run_move(self.connection, UInt32(oldQueuePos), UInt32(newQueuePos))
  }

  func sendAddSongToQueue(uri: String, at queuePos: Int) {
    mpd_run_add_id_to(self.connection, uri, UInt32(queuePos))
  }

  func sendAddAlbumToQueue(album: MPDAlbum, at queuePos: Int) {
    let songs = searchSongs([MPDTag.album: album.title, MPDTag.artist: album.artist])

    var insertPos = UInt32(queuePos)

    for song in songs {
      mpd_run_add_id_to(self.connection, song.uri, insertPos)

      insertPos += 1
    }
  }
}
