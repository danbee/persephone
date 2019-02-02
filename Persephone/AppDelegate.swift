//
//  AppDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2018/7/31.
//  Copyright © 2018 Dan Barber. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  static let mpdClient = MPDClient(
    withDelegate: MPDClientNotificationHandler() as MPDClientDelegate
  )
 
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    AppDelegate.mpdClient.connect()
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    AppDelegate.mpdClient.disconnect()
  }
}
