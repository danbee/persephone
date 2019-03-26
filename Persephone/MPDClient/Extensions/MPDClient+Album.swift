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
    enqueueCommand(command: .fetchAllAlbums)
  }

  func playAlbum(_ album: MPDAlbum) {
    enqueueCommand(command: .playAlbum, userData: ["album": album])
  }

  func getAlbumFirstSong(for album: MPDAlbum, callback: @escaping (String?) -> Void) {
    enqueueCommand(
      command: .getAlbumFirstSong,
      priority: .low,
      userData: ["album": album, "callback": callback]
    )
  }

  func sendPlayAlbum(_ album: MPDAlbum) {
    var songs: [MPDSong] = []

    mpd_run_clear(self.connection)
    mpd_search_db_songs(self.connection, true)
    mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM, album.title)
    mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM_ARTIST, album.artist)
    mpd_search_commit(self.connection)
    while let song = mpd_recv_song(self.connection) {
      songs.append(MPDSong(song))
    }
    for song in songs {
      mpd_run_add(self.connection, song.uri)
    }
    mpd_run_play_pos(self.connection, 0)
  }

  func allAlbums() {
    var albums: [MPDAlbum] = []
    var artist: String = ""

    mpd_search_db_tags(self.connection, MPD_TAG_ALBUM)
    mpd_search_add_group_tag(self.connection, MPD_TAG_ALBUM_ARTIST)
    mpd_search_commit(self.connection)

    while let pair = mpd_recv_pair(self.connection) {
      let pair = MPDPair(pair)

      switch pair.name {
      case "AlbumArtist":
        artist = pair.value
      case "Album":
        albums.append(MPDAlbum(title: pair.value, artist: artist))
      default:
        break
      }

      mpd_return_pair(self.connection, pair.pair)
    }

    self.delegate?.didLoadAlbums(mpdClient: self, albums: albums)
  }

  func albumFirstSong(for album: MPDAlbum, callback: @escaping (MPDSong?) -> Void) {
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
}
