//
//  MPDServerDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/8/02.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

class MPDServerDelegate: MPDClientDelegate {
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
