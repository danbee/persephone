//
//  AlbumTracksDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class AlbumTracksDataSource: NSObject, NSTableViewDataSource {
  var albumTracks: [Song] = []

  func numberOfRows(in tableView: NSTableView) -> Int {
    return albumTracks.count
  }
}
