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

  func playAlbum(_ album: Album) {
    enqueueCommand(command: .playAlbum, userData: ["album": album])
  }

  func getAlbumURI(for album: Album, callback: @escaping (String?) -> Void) {
    enqueueCommand(
      command: .getAlbumURI,
      priority: .low,
      userData: ["album": album, "callback": callback]
    )
  }

  func sendPlayAlbum(_ album: Album) {
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

  func allAlbums() {
    var albums: [Album] = []
    var artist: String = ""

    mpd_search_db_tags(self.connection, MPD_TAG_ALBUM)
    mpd_search_add_group_tag(self.connection, MPD_TAG_ALBUM_ARTIST)
    mpd_search_commit(self.connection)

    while let mpdPair = mpd_recv_pair(self.connection) {
      let pair = Pair(mpdPair)

      switch pair.name {
      case "AlbumArtist":
        artist = pair.value
      case "Album":
        albums.append(Album(title: pair.value, artist: artist))
      default:
        break
      }

      mpd_return_pair(self.connection, pair.mpdPair)
    }

    self.delegate?.didLoadAlbums(mpdClient: self, albums: albums)
  }

  func albumURI(for album: Album, callback: (String?) -> Void) {
    var songURI: String?

    guard isConnected else { return }

    mpd_search_db_songs(self.connection, true)
    mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM, album.title)
    mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, MPD_TAG_ALBUM_ARTIST, album.artist)
    mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, MPD_TAG_TRACK, "1")

    mpd_search_commit(self.connection)

    while let mpdSong = mpd_recv_song(self.connection) {
      let song = Song(mpdSong)

      if songURI == nil {
        songURI = song.uriString
      }
    }

    callback(
      songURI?
        .split(separator: "/")
        .dropLast()
        .joined(separator: "/")
    )
  }
}
