//
//  Notification.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension Notification {
  static let didConnect = Notification.Name("MPDClientDidConnect")
  static let willDisconnect = Notification.Name("MPDClientWillDisconnect")

  static let stateChanged = Notification.Name("MPDClientStateChanged")
  static let queueChanged = Notification.Name("MPDClientQueueChanged")
  static let queuePosChanged = Notification.Name("MPDClientQueuePosChanged")
  static let loadedAlbums = Notification.Name("MPDClientLoadedAlbums")

  static let stateKey = "state"
  static let queueKey = "queue"
  static let queuePosKey = "song"
  static let albumsKey = "albums"
}
