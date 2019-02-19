//
//  Notification.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension Notification {
  static let didConnect = Name("MPDClientDidConnect")
  static let willDisconnect = Name("MPDClientWillDisconnect")

  static let stateChanged = Name("MPDClientStateChanged")
  static let timeChanged = Name("MPDClientTimeChanged")
  static let queueChanged = Name("MPDClientQueueChanged")
  static let queuePosChanged = Name("MPDClientQueuePosChanged")
  static let loadedAlbums = Name("MPDClientLoadedAlbums")

  static let stateKey = "state"
  static let queueKey = "queue"
  static let queuePosKey = "song"
  static let albumsKey = "albums"
  static let totalTimeKey = "totalTime"
  static let elapsedTimeMsKey = "elapsedTimeMs"
}
