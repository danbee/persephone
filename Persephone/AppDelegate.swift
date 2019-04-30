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

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    App.mpdServerController.connect()

    mediaKeyTap = MediaKeyTap(delegate: self)
    mediaKeyTap?.start()

    App.store.subscribe(self) {
      $0.select { $0.playerState.databaseUpdating }
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    App.mpdServerController.disconnect()
  }

  func handle(mediaKey: MediaKey, event: KeyEvent) {
    switch mediaKey {
    case .playPause:
      App.store.dispatch(MPDPlayPauseAction())
    case .next, .fastForward:
      App.store.dispatch(MPDNextTrackAction())
    case .previous, .rewind:
      App.store.dispatch(MPDPrevTrackAction())
    }
  }

  @IBAction func updateDatabase(_ sender: NSMenuItem) {
    App.store.dispatch(MPDUpdateDatabaseAction())
  }

  @IBOutlet weak var updateDatabaseMenuItem: NSMenuItem!
}

extension AppDelegate: StoreSubscriber {
  typealias StoreSubscriberStateType = Bool

  func newState(state: Bool) {
    updateDatabaseMenuItem.isEnabled = !state
  }
}
