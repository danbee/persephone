//
//  Idle.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/09.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension MPDClient {
  struct MPDIdle: OptionSet {
    let rawValue: UInt32

    static let database = MPDIdle(rawValue: 0x1)
    static let storedPlaylist = MPDIdle(rawValue: 0x2)
    static let queue = MPDIdle(rawValue: 0x4)
    static let player = MPDIdle(rawValue: 0x8)
    static let mixer = MPDIdle(rawValue: 0x10)
    static let output = MPDIdle(rawValue: 0x20)
    static let options = MPDIdle(rawValue: 0x40)
    static let update = MPDIdle(rawValue: 0x80)
    static let sticker = MPDIdle(rawValue: 0x100)
    static let subscription = MPDIdle(rawValue: 0x200)
    static let message = MPDIdle(rawValue: 0x400)
  }
}
