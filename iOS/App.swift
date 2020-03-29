//
//  App.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/30.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

struct App {
  static let store = Store<AppState>(reducer: appReducer, state: nil)
  static let trackTimer = TrackTimer()
  //static let userNotificationsController = UserNotificationsController()
  static let mpdServerDelegate = MPDServerDelegate()
  static let mpdServerController = MPDServerController(delegate: mpdServerDelegate)
  static var mpdClient: MPDClient!
}
