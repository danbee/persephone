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
    App.mpdClient = MPDClient(withDelegate: App.mpdServerDelegate)
    
    App.store.subscribe(self) {
      $0.select { $0.preferencesState.mpdServer }
    }
  }
  
  func connect() {
    let mpdServer = App.store.state.preferencesState.mpdServer

    App.mpdClient.connect(
      host: mpdServer.hostOrDefault,
      port: mpdServer.portOrDefault
    )
  }
  
  func disconnect() {
    App.mpdClient.disconnect()
  }
}

extension MPDServerController: StoreSubscriber {
  typealias StoreSubscriberStateType = MPDServer

  func newState(state: MPDServer) {
    guard App.mpdClient != nil else { return }
    
    disconnect()
    connect()
  }
}
