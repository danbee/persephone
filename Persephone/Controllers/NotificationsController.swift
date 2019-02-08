//
//  MPDClientNotificationHandler.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/02.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

class NotificationsController: MPDClientDelegate {
  let notificationQueue = DispatchQueue.main
  
  func didUpdateState(mpdClient: MPDClient, state: MPDClient.Status.State) {
    sendNotification(
      name: Notification.stateChanged,
      userInfo: [Notification.stateKey: state]
    )
  }

  func didUpdateQueue(mpdClient: MPDClient, queue: [MPDClient.Song]) {
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

  private func sendNotification(name: Notification.Name, userInfo: [AnyHashable : Any]) {
    self.notificationQueue.async {
      NotificationCenter.default.post(
        name: name,
        object: AppDelegate.mpdClient,
        userInfo: userInfo
      )
    }
  }
}
