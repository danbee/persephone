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
  struct MPDError: Error {
    let mpdError: mpd_error
    let recovered: Bool
    let message: String
  }
}
