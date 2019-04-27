//
//  NotificationsController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/02.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

class NotificationsController: MPDClientDelegate {
  let notificationQueue = DispatchQueue.main

  func didConnect(mpdClient: MPDClient) {
    sendNotification(name: Notification.didConnect)
  }

  func willDisconnect(mpdClient: MPDClient) {
    DispatchQueue.main.async {
      AppDelegate.store.dispatch(UpdateAlbumListAction(albums: []))
    }
    sendNotification(name: Notification.willDisconnect)
  }

  func didUpdateStatus(mpdClient: MPDClient, status: MPDClient.MPDStatus) {
    DispatchQueue.main.async {
      AppDelegate.store.dispatch(UpdateStatusAction(status: status))
    }
  }

  func willStartDatabaseUpdate(mpdClient: MPDClient) {
    DispatchQueue.main.async {
      AppDelegate.store.dispatch(StartedDatabaseUpdate())
    }
  }

  func didFinishDatabaseUpdate(mpdClient: MPDClient) {
    DispatchQueue.main.async {
      AppDelegate.store.dispatch(FinishedDatabaseUpdate())
    }
  }

  func didUpdateQueue(mpdClient: MPDClient, queue: [MPDClient.MPDSong]) {
    DispatchQueue.main.async {
      AppDelegate.store.dispatch(UpdateQueueAction(queue: queue))
    }
  }

  func didUpdateQueuePos(mpdClient: MPDClient, song: Int) {
    DispatchQueue.main.async {
      AppDelegate.store.dispatch(UpdateQueuePosAction(queuePos: song))
    }
  }

  func didLoadAlbums(mpdClient: MPDClient, albums: [MPDClient.MPDAlbum]) {
    DispatchQueue.main.async {
      AppDelegate.store.dispatch(UpdateAlbumListAction(albums: albums))
    }
  }

  private func sendNotification(name: Notification.Name, userInfo: [AnyHashable : Any] = [:]) {
    self.notificationQueue.async {
      NotificationCenter.default.post(
        name: name,
        object: AppDelegate.mpdClient,
        userInfo: userInfo
      )
    }
  }
}
