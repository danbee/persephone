//
//  MPDClientStatus.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/04.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  class MPDStatus {
    private let status: OpaquePointer

    enum State: UInt {
      case unknown = 0
      case stopped = 1
      case playing = 2
      case paused = 3
    }

    init(_ status: OpaquePointer) {
      self.status = status
    }

    deinit {
      mpd_status_free(status)
    }

    var state: State {
      let mpdState = mpd_status_get_state(status)

      return State(rawValue: UInt(mpdState.rawValue))!
    }

    var totalTime: UInt {
      let mpdTotalTime = mpd_status_get_total_time(status)

      return UInt(mpdTotalTime)
    }

    var elapsedTimeMs: UInt {
      let mpdElapsedTimeMs = mpd_status_get_elapsed_ms(status)

      return UInt(mpdElapsedTimeMs)
    }

    var song: Int {
      return Int(mpd_status_get_song_pos(status))
    }

    var updating: Bool {
      let updating = mpd_status_get_update_id(status)

      return updating > 0
    }
  }
}
