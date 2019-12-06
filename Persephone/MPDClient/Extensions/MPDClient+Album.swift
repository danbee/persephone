//
//  MPDAlbum.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func fetchAllAlbums() {
    enqueueCommand(command: .fetchAlbums, userData: ["filter": ""])
  }

  func fetchAlbums(filter: String) {
    enqueueCommand(command: .fetchAlbums, userData: ["filter": filter])
  }

  func playAlbum(_ album: MPDAlbum) {
    enqueueCommand(command: .playAlbum, userData: ["album": album])
  }

  func getAlbumFirstSong(for album: MPDAlbum, callback: @escaping (MPDSong?) -> Void) {
    enqueueCommand(
      command: .getAlbumFirstSong,
      priority: .low,
      userData: ["album": album, "callback": callback]
    )
  }

  func getAlbumSongs(for album: MPDAlbum, callback: @escaping ([MPDSong]) -> Void) {
    enqueueCommand(
      command: .getAlbumSongs,
      priority: .normal,
      userData: ["album": album, "callback": callback]
    )
  }

  func sendPlayAlbum(_ album: MPDAlbum) {
    getAlbumSongs(for: album) { songs in
      self.enqueueCommand(
        command: .replaceQueue,
        priority: .normal,
        userData: ["songs": songs]
      )
      self.enqueueCommand(command: .fetchQueue)
      self.enqueueCommand(
        command: .playTrack,
        priority: .normal,
        userData: ["queuePos": 0]
      )
    }
  }

  func albums(filter: String) {
    var albums: [MPDAlbum] = []

    mpd_search_db_songs(self.connection, false)
    if filter != "" {
      mpd_search_add_expression(
        self.connection,
        "(any contains '\(filter)')"
      )
    }
    mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, MPD_TAG_TRACK, "1")

    mpd_search_commit(self.connection)

    while let song = mpd_recv_song(self.connection) {
      let mpdSong = MPDSong(song)

      let mpdAlbum = MPDAlbum(
        title: mpdSong.album.title,
        artist: mpdSong.artist,
        date: mpdSong.date,
        path: mpdSong.path
      )
      if (mpdAlbum != albums.last) {
        albums.append(mpdAlbum)
      }
    }

    self.delegate?.didLoadAlbums(mpdClient: self, albums: albums)
  }

  func albumFirstSong(for album: MPDAlbum, callback: (MPDSong?) -> Void) {
    guard isConnected else { return }

    var firstSong: MPDSong?

    mpd_search_db_songs(self.connection, true)
    mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM, album.title)
    mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM_ARTIST, album.artist)
    mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, MPD_TAG_TRACK, "1")

    mpd_search_commit(self.connection)

    while let song = mpd_recv_song(self.connection) {
      let song = MPDSong(song)

      if firstSong == nil {
        firstSong = song
      }
    }

    callback(firstSong)
  }

  func albumSongs(for album: MPDAlbum, callback: ([MPDSong]) -> Void) {
    guard isConnected else { return }

    let songs = searchSongs([MPDTag.album: album.title, MPDTag.albumArtist: album.artist])

    callback(songs)
  }
}
