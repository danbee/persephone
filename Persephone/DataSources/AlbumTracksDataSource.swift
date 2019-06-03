//
//  AlbumTracksDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class AlbumTracksDataSource: NSObject, NSTableViewDataSource {
  struct AlbumSongItem {
    let disc: String?
    let song: Song?

    init(song: Song) {
      self.disc = nil
      self.song = song
    }

    init(disc: String) {
      self.disc = disc
      self.song = nil
    }
  }

  var albumSongs: [AlbumSongItem] = []

  func setAlbumSongs(_ songs: [Song]) {
    var disc: String? = ""

    songs.forEach { song in
      if song.disc != disc {
        disc = song.disc
        albumSongs.append(AlbumSongItem(disc: song.disc))
      }

      albumSongs.append(AlbumSongItem(song: song))
    }
  }

  func numberOfRows(in tableView: NSTableView) -> Int {
    return albumSongs.count
  }
}
