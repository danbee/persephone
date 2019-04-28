//
//  MPDServerController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import ReSwift

class MPDServerController {
  init() {
    AppDelegate.store.subscribe(self) {
      $0.select { $0.preferencesState.mpdServer }
    }
  }

  func connect() {
    AppDelegate.mpdClient.connect(
      host: AppDelegate.store.state.preferencesState.mpdServer.hostOrDefault,
      port: AppDelegate.store.state.preferencesState.mpdServer.portOrDefault
    )
  }

  func disconnect() {
    AppDelegate.mpdClient.disconnect()
  }
}

extension MPDServerController: StoreSubscriber {
  typealias StoreSubscriberStateType = MPDServer

  func newState(state: MPDServer) {
    disconnect()
    connect()
  }
}
