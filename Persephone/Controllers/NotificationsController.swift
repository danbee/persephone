//
//  MPDClientNotificationHandler.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/02.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

class NotificationsController: MPDClientDelegate {
  let notificationQueue = DispatchQueue.main
  
  func didUpdateState(mpdClient: MPDClient, state: mpd_state) {
    sendNotification(
      name: MPDClient.stateChanged,
      userInfo: [MPDClient.stateKey: state]
    )
  }

  func didUpdateQueue(mpdClient: MPDClient, queue: [MPDClient.Song]) {
    sendNotification(
      name: MPDClient.queueChanged,
      userInfo: [MPDClient.queueKey: queue]
    )
  }

  func didUpdateQueuePos(mpdClient: MPDClient, song: Int32) {
    sendNotification(
      name: MPDClient.queuePosChanged,
      userInfo: [MPDClient.queuePosKey: song]
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
