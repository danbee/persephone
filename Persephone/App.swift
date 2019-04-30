//
//  App.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/30.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import ReSwift

struct App {
  static let userNotificationsController = UserNotificationsController()
  static let mpdServerController = MPDServerController()
  static let mpdClient = MPDClient(withDelegate: NotificationsController())
  static let trackTimer = TrackTimer()
  static let store = Store<AppState>(reducer: appReducer, state: nil)
}
