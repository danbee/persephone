//
//  DraggedSong.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/21.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

struct DraggedSong: Codable {
  var type: DraggedSongType
  var title: String
  var artist: String
  var albumArtist: String
  var album: String
  var uri: String
}
