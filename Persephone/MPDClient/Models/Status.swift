//
//  MPDClientStatus.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/04.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension RawRepresentable where Self: Equatable {
  func isOneOf<Options: Sequence>(_ options: Options) -> Bool where Options.Element == Self {
    return options.contains(self)
  }
}

extension MPDClient {
  class Status {
    private let mpdStatus: OpaquePointer

    enum State: UInt {
      case unknown = 0
      case stopped = 1
      case playing = 2
      case paused = 3
    }

    init(_ mpdStatus: OpaquePointer) {
      self.mpdStatus = mpdStatus
    }

    deinit {
      mpd_status_free(mpdStatus)
    }

    var state: State {
      let mpdState = mpd_status_get_state(mpdStatus)

      return State(rawValue: UInt(mpdState.rawValue))!
    }

    var song: Int {
      return Int(mpd_status_get_song_pos(mpdStatus))
    }

  }
}
