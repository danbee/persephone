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
    App.store.subscribe(self) {
      $0.select { $0.preferencesState.mpdServer }
    }
  }

  func connect() {
    App.store.dispatch(
      MPDConnectAction(
        host: App.store.state.preferencesState.mpdServer.hostOrDefault,
        port: App.store.state.preferencesState.mpdServer.portOrDefault
      )
    )
  }

  func disconnect() {
    App.store.dispatch(MPDDisconnectAction())
  }
}

extension MPDServerController: StoreSubscriber {
  typealias StoreSubscriberStateType = MPDServer

  func newState(state: MPDServer) {
    disconnect()
    connect()
  }
}
