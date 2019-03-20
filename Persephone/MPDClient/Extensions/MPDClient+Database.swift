//
//  MPDClient+Database.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func updateDatabase() {
    enqueueCommand(command: .updateDatabase)
  }

  func sendUpdateDatabase() {
    mpd_run_update(connection, nil)
  }
}
