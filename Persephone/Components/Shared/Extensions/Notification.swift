//
//  Notification.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension Notification.Name {
  static let didConnect = Notification.Name("MPDClientDidConnect")
  static let willDisconnect = Notification.Name("MPDClientWillDisconnect")
  static let didReloadAlbumArt = Notification.Name("MPDDidReloadAlbumArt")
  static let didRaiseError = Notification.Name("MPDDidRaiseError")
}
