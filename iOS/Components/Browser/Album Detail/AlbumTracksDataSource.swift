//
//  AlbumTracksDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import UIKit

class AlbumTracksDataSource: NSObject, UITableViewDataSource {
  var albumSongs: [AlbumSongItem] = []

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albumSongs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let albumSongItem = albumSongs[indexPath.row]
    
    if let song = albumSongItem.song {
      guard let albumSongCell = tableView.dequeueReusableCell(withIdentifier: "albumSongCell") as? AlbumSongCell
        else { return AlbumSongCell() }
      
      albumSongCell.setSongItem(songItem: albumSongItem)

      return albumSongCell
    } else if let disc = albumSongItem.disc {
      guard let albumDiscCell = tableView.dequeueReusableCell(withIdentifier: "albumDiscCell") as? AlbumDiscCell
        else { return AlbumDiscCell() }
      
      albumDiscCell.setSongItem(songItem: albumSongItem)
      
      return albumDiscCell
    }
    
    return UITableViewCell()
  }

  func setAlbumSongs(_ songs: [Song]) {
    var disc: String? = ""

    songs.forEach { song in
      if song.disc != disc && song.disc != "0" {
        disc = song.disc
        albumSongs.append(AlbumSongItem(disc: song.disc))
      }

      albumSongs.append(AlbumSongItem(song: song))
    }
  }
}
