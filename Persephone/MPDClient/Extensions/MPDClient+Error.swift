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
