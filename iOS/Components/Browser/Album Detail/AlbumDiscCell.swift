//
//  AlbumDiscCell.swift
//  Persephone-iOS
//
//  Created by Daniel Barber on 2020-3-31.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit

class AlbumDiscCell: UITableViewCell {
  var albumSongItem: AlbumSongItem?
  
  func setSongItem(songItem: AlbumSongItem) {
    albumSongItem = songItem
    
    albumDisc.text = "Disc \(songItem.disc ?? "0")"
  }

  @IBOutlet var albumDisc: UILabel!
}
