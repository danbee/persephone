//
//  Idle.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/09.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension MPDClient {
  struct Idle: OptionSet {
    let rawValue: UInt32

    static let database = Idle(rawValue: 0x1)
    static let storedPlaylist = Idle(rawValue: 0x2)
    static let queue = Idle(rawValue: 0x4)
    static let player = Idle(rawValue: 0x8)
    static let mixer = Idle(rawValue: 0x10)
    static let output = Idle(rawValue: 0x20)
    static let options = Idle(rawValue: 0x40)
    static let update = Idle(rawValue: 0x80)
    static let sticker = Idle(rawValue: 0x100)
    static let subscription = Idle(rawValue: 0x200)
    static let message = Idle(rawValue: 0x400)
  }
}
