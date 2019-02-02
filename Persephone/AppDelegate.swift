//
//  AppDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2018/7/31.
//  Copyright © 2018 Dan Barber. All rights reserved.
//

import Cocoa

extension MPDClient {
  static let shared = MPDClient(notificationQueue: .main)
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    MPDClient.shared.connect()
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    MPDClient.shared.disconnect()
  }
}
