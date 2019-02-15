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
  var preferences = Preferences()

  static let mpdClient = MPDClient(
    withDelegate: NotificationsController()
  )
 
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    connect()

    UserDefaults.standard.addObserver(self, forKeyPath: "mpdHost", options: .new, context: nil)
    UserDefaults.standard.addObserver(self, forKeyPath: "mpdPort", options: .new, context: nil)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    disconnect()
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    switch keyPath {
    case "mpdHost", "mpdPort":
      disconnect()
      connect()
    default:
      break
    }
  }

  func connect() {
    AppDelegate.mpdClient.connect(
      host: preferences.mpdHostOrDefault,
      port: preferences.mpdPortOrDefault
    )
  }

  func disconnect() {
    AppDelegate.mpdClient.disconnect()
  }
}
