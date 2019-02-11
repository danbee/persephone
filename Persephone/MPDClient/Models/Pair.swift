//
//  Pair.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/09.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

class Pair {
  let mpdPair: UnsafeMutablePointer<mpd_pair>

  init(_ mpdPair: UnsafeMutablePointer<mpd_pair>) {
    self.mpdPair = mpdPair
  }

  var name: String {
    get { return String(cString: mpdPair.pointee.name) }
  }

  var value: String {
    get { return String(cString: mpdPair.pointee.value) }
  }
}
