//
//  AppDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2018/7/31.
//  Copyright © 2018 Dan Barber. All rights reserved.
//

import AppKit
import ReSwift
import MediaKeyTap

@NSApplicationMain
class AppDelegate: NSObject,
                   NSApplicationDelegate,
                   MediaKeyTapDelegate {
  var mediaKeyTap: MediaKeyTap?
  var userNotificationsController = UserNotificationsController()
  var mpdServerController = MPDServerController()

  static let mpdClient = MPDClient(
    withDelegate: NotificationsController()
  )

  static let trackTimer = TrackTimer()

  static let store = Store<AppState>(reducer: appReducer, state: nil)

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    mpdServerController.connect()

    mediaKeyTap = MediaKeyTap(delegate: self)
    mediaKeyTap?.start()

    AppDelegate.store.subscribe(self) {
      $0.select { $0.playerState.databaseUpdating }
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    mpdServerController.disconnect()
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

  @IBAction func updateDatabase(_ sender: NSMenuItem) {
    AppDelegate.mpdClient.updateDatabase()
  }

  @IBOutlet weak var updateDatabaseMenuItem: NSMenuItem!
}

extension AppDelegate: StoreSubscriber {
  typealias StoreSubscriberStateType = Bool

  func newState(state: Bool) {
    updateDatabaseMenuItem.isEnabled = !state
  }
}
