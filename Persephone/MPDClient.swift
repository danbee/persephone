//
//  MPDClient.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/1/25.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

class MPDClient {
  let HOST = "localhost"
  let PORT: UInt32 = 6600
  private let connection: OpaquePointer
  private var status: OpaquePointer?

  init?() {
    guard let connection = mpd_connection_new(HOST, PORT, 0)
      else { return nil }

    mpd_connection_set_keepalive(connection, true)

    self.connection = connection
  }

  deinit {
    mpd_connection_free(connection)
  }

  func getStatus() {
    status = mpd_status_begin()
  }

  func playPause() {
    mpd_run_toggle_pause(connection)
  }

  func stop() {
    mpd_run_stop(connection)
  }

  func prevTrack() {
    mpd_run_previous(connection)
  }

  func nextTrack() {
    mpd_run_next(connection)
  }

  func getLastErrorMessage() -> String! {
    if mpd_connection_get_error(connection) == MPD_ERROR_SUCCESS {
      return "no error"
    }

    if let errorMessage = mpd_connection_get_error_message(connection) {
      return String(cString: errorMessage)
    }

    return "no error message"
  }
}
