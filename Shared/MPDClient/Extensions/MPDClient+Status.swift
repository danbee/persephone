//
//  Status.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func fetchStatus() {
    sendCommand(command: .fetchStatus)
  }

  func sendRunStatus() {
    guard let status = mpd_run_status(connection) else { return }
    self.status = MPDStatus(status)
  }
}
