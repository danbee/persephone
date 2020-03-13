//
//  DraggedAlbum.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import CryptoSwift

struct DraggedAlbum: Codable {
  var title: String
  var artist: String

  var hash: String {
    return "\(title) - \(artist)".sha1()
  }
}
