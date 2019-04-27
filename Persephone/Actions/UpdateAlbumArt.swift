//
//  UpdateAlbumArt.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/27.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import ReSwift

struct UpdateAlbumArt: Action {
  var coverArt: NSImage?
  var albumIndex: Int
}
