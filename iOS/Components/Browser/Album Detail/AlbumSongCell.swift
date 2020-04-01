//
//  AlbumSongCell.swift
//  Persephone
//
//  Created by Daniel Barber on 2020-3-30.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit

class AlbumSongCell: UITableViewCell {
  var albumSongItem: AlbumSongItem?
  
  func setSongItem(songItem: AlbumSongItem) {
    albumSongItem = songItem
    
    trackNumber.text = songItem.song?.trackNumber
    songTitle.text = songItem.song?.title
  }
  
  @IBOutlet var trackNumber: UILabel!
  @IBOutlet var songTitle: UILabel!
  @IBOutlet var songDuration: UILabel!
}
