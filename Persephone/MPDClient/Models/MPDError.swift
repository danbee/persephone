//
//  MPDError.swift
//  Persephone
//
//  Created by Daniel Barber on 2/23/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  enum MPDError: Error {
    init(mpdError: mpd_error, message: String) {
      switch mpdError {
      case MPD_ERROR_OOM:
        self = .outOfMemory(message)
      case MPD_ERROR_ARGUMENT:
        self = .argument(message)
      case MPD_ERROR_STATE:
        self = .state(message)
      case MPD_ERROR_TIMEOUT:
        self = .timeout(message)
      case MPD_ERROR_SYSTEM:
        self = .system(message)
      case MPD_ERROR_RESOLVER:
        self = .resolver(message)
      case MPD_ERROR_MALFORMED:
        self = .malformed(message)
      case MPD_ERROR_CLOSED:
        self = .closed(message)
      case MPD_ERROR_SERVER:
        self = .server(message)
      default:
        self = .success
      }
    }

    case success
    case outOfMemory(String)
    case argument(String)
    case state(String)
    case timeout(String)
    case system(String)
    case resolver(String)
    case malformed(String)
    case closed(String)
    case server(String)
  }
}
