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
    DispatchQueue.main.async {
      App.store.dispatch(MPDConnectAction())
    }
  }

  func disconnect() {
    DispatchQueue.main.async {
      App.store.dispatch(MPDDisconnectAction())
    }
  }
}

extension MPDServerController: StoreSubscriber {
  typealias StoreSubscriberStateType = MPDServer

  func newState(state: MPDServer) {
    disconnect()
    connect()
  }
}

extension MPDServerController: MPDClientDelegate {
  func didConnect(mpdClient: MPDClient) {}

  func willDisconnect(mpdClient: MPDClient) {
    DispatchQueue.main.async {
      App.store.dispatch(UpdateAlbumListAction(albums: []))
    }
  }

  func didUpdateStatus(mpdClient: MPDClient, status: MPDClient.MPDStatus) {
    DispatchQueue.main.async {
      App.store.dispatch(UpdateStatusAction(status: status))
    }
  }

  func willStartDatabaseUpdate(mpdClient: MPDClient) {
    DispatchQueue.main.async {
      App.store.dispatch(DatabaseUpdateStartedAction())
    }
  }

  func didFinishDatabaseUpdate(mpdClient: MPDClient) {
    DispatchQueue.main.async {
      App.store.dispatch(DatabaseUpdateFinishedAction())
    }
  }

  func didUpdateQueue(mpdClient: MPDClient, queue: [MPDClient.MPDSong]) {
    DispatchQueue.main.async {
      App.store.dispatch(UpdateQueueAction(queue: queue))
    }
  }

  func didUpdateQueuePos(mpdClient: MPDClient, song: Int) {
    DispatchQueue.main.async {
      App.store.dispatch(UpdateQueuePosAction(queuePos: song))
    }
  }

  func didLoadAlbums(mpdClient: MPDClient, albums: [MPDClient.MPDAlbum]) {
    DispatchQueue.main.async {
      App.store.dispatch(UpdateAlbumListAction(albums: albums))
    }
  }
}
