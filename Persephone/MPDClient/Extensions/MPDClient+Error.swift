//
//  Error.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func checkError() -> Bool {
    let error = mpd_connection_get_error(connection)

    if error != MPD_ERROR_SUCCESS {
      return handleError(mpdError: error)
    }
    
    return true
  }

  func handleError(mpdError: mpd_error) -> Bool {
    guard let errorMessage = mpd_connection_get_error_message(connection)
      else { return true }

    let message = String(cString: errorMessage)
    
    let recovered = mpd_connection_clear_error(connection)

    let error = MPDError(
      mpdError: mpdError,
      recovered: recovered,
      message: message
    )
    delegate?.didRaiseError(mpdClient: self, error: error)

    return recovered
  }

  func getLastErrorMessage() -> String? {
    if mpd_connection_get_error(connection) == MPD_ERROR_SUCCESS {
      return nil
    }

    if let errorMessage = mpd_connection_get_error_message(connection) {
      return String(cString: errorMessage)
    }

    return nil
  }
}
