//
//  AppDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2018/7/31.
//  Copyright © 2018 Dan Barber. All rights reserved.
//

import Cocoa
import ReSwift
import MediaKeyTap

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, MediaKeyTapDelegate {
  var preferences = Preferences()
  var mediaKeyTap: MediaKeyTap?

  static let mpdClient = MPDClient(
    withDelegate: NotificationsController()
  )

  static let trackTimer = TrackTimer()

  static let store = Store(reducer: appReducer, state: nil)

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    connect()

    preferences.addObserver(self, forKeyPath: "mpdHost")
    preferences.addObserver(self, forKeyPath: "mpdPort")

    mediaKeyTap = MediaKeyTap(delegate: self)
    mediaKeyTap?.start()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(enableUpdateDatabaseMenuItem),
      name: Notification.databaseUpdateFinished,
      object: AppDelegate.mpdClient
    )
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    disconnect()
  }

  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    switch keyPath {
    case "mpdHost", "mpdPort":
      disconnect()
      connect()
    default:
      break
    }
  }

  func handle(mediaKey: MediaKey, event: KeyEvent) {
    switch mediaKey {
    case .playPause:
      AppDelegate.mpdClient.playPause()
    case .next, .fastForward:
      AppDelegate.mpdClient.nextTrack()
    case .previous, .rewind:
      AppDelegate.mpdClient.prevTrack()
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

  @IBAction func updateDatabase(_ sender: NSMenuItem) {
    sender.isEnabled = false
    AppDelegate.mpdClient.updateDatabase()
  }

  @objc func enableUpdateDatabaseMenuItem() {
    updateDatabaseMenuItem?.isEnabled = true
  }

  @IBOutlet weak var updateDatabaseMenuItem: NSMenuItem!
}
