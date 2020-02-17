//
//  MPDClient+Mixer.swift
//  Persephone
//
//  Created by Daniel Barber on 2/16/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func setVolume(to volume: Int) {
    enqueueCommand(
      command: .setVolume,
      priority: .high,
      userData: ["volume": volume]
    )
  }
  
  func sendSetVolume(to volume: Int) {
    mpd_run_set_volume(connection, UInt32(volume))
  }
}
