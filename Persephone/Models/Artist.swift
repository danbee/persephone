//
//  Artist.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/10/04.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

struct Artist {
  var name: String
  var image: Loading<NSImage?> = .notLoaded

  init(name: String) {
    self.name = name
  }
}

extension Artist: Equatable {
  static func == (lhs: Artist, rhs: Artist) -> Bool {
    return (lhs.name == rhs.name)
  }
}
