//
//  AlbumSongCell.swift
//  Persephone-iOS
//
//  Created by Daniel Barber on 2020-3-30.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit

class AlbumSongCell: UITableViewCell {
  var albumSongItem: AlbumSongItem?
  
  func setSongItem(songItem: AlbumSongItem) {
    albumSongItem = songItem
    
    guard let song = songItem.song else { return }
    
    songDuration.font = .timerFont

    trackNumber.text = song.trackNumber
    songTitle.text = song.title
    songDuration.text = song.duration.formattedTime
  }
  
  @IBOutlet var trackNumber: UILabel!
  @IBOutlet var songTitle: UILabel!
  @IBOutlet var songDuration: UILabel!
}
