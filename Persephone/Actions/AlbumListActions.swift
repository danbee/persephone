//
//  AlbumListActions.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import ReSwift

struct ResetAlbumListCoverArt: Action {}

struct UpdateCoverArt: Action {
  var coverArt: NSImage?
  var albumIndex: Int
}

struct UpdateAlbumListAction: Action {
  var albums: [MPDClient.MPDAlbum]
}
