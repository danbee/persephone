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
    sendNotification(name: Notification.willDisconnect)
  }

  func didUpdateStatus(mpdClient: MPDClient, status: MPDClient.MPDStatus) {
    AppDelegate.store.dispatch(UpdateStatusAction(status: status))
    sendNotification(
      name: Notification.stateChanged,
      userInfo: [Notification.stateKey: status.state]
    )
    sendNotification(
      name: Notification.timeChanged,
      userInfo: [
        Notification.totalTimeKey: status.totalTime,
        Notification.elapsedTimeMsKey: status.elapsedTimeMs
      ]
    )
  }

  func didUpdateTime(mpdClient: MPDClient, total: UInt, elapsedMs: UInt) {

  }

  func willStartDatabaseUpdate(mpdClient: MPDClient) {
    sendNotification(name: Notification.databaseUpdateStarted)
  }

  func didFinishDatabaseUpdate(mpdClient: MPDClient) {
    sendNotification(name: Notification.databaseUpdateFinished)
  }

  func didUpdateQueue(mpdClient: MPDClient, queue: [MPDClient.MPDSong]) {
    //AppDelegate.store.dispatch(UpdateQueueAction(queue: queue))
    sendNotification(
      name: Notification.queueChanged,
      userInfo: [Notification.queueKey: queue]
    )
  }

  func didUpdateQueuePos(mpdClient: MPDClient, song: Int) {
    sendNotification(
      name: Notification.queuePosChanged,
      userInfo: [Notification.queuePosKey: song]
    )
  }

  func didLoadAlbums(mpdClient: MPDClient, albums: [MPDClient.MPDAlbum]) {
    sendNotification(
      name: Notification.loadedAlbums,
      userInfo: [Notification.albumsKey: albums]
    )
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
