//
//  AppDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2018/7/31.
//  Copyright © 2018 Dan Barber. All rights reserved.
//

import Cocoa
import MediaKeyTap

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, MediaKeyTapDelegate {
  var preferences = Preferences()
  var mediaKeyTap: MediaKeyTap?

  static let mpdClient = MPDClient(
    withDelegate: NotificationsController()
  )

  @IBAction func fetchCoverArt(_ sender: NSMenuItem) {
    NotificationCenter.default.post(
      name: Notification.Name("fetchAlbumArt"),
      object: self,
      userInfo: nil
    )
  }

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    connect()

    preferences.addObserver(self, forKeyPath: "mpdHost")
    preferences.addObserver(self, forKeyPath: "mpdPort")

    mediaKeyTap = MediaKeyTap(delegate: self)
    mediaKeyTap?.start()
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
}
