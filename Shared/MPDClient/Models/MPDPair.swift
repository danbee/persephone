//
//  Pair.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/09.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  class MPDPair {
    let pair: UnsafeMutablePointer<mpd_pair>

    init(_ pair: UnsafeMutablePointer<mpd_pair>) {
      self.pair = pair
    }

    var name: String {
      get { return String(cString: pair.pointee.name) }
    }

    var value: String {
      get { return String(cString: pair.pointee.value) }
    }
  }
}
