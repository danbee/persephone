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
  class Status {
    let mpdStatus: OpaquePointer

    init(_ mpdStatus: OpaquePointer) {
      self.mpdStatus = mpdStatus
    }

    deinit {
      mpd_status_free(mpdStatus)
    }

    func state() -> mpd_state {
      return mpd_status_get_state(mpdStatus)
    }

    func song() -> Int32 {
      return mpd_status_get_song_pos(mpdStatus)
    }
  }
}
