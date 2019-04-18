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
    _ = App.userNotificationsController

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

  func setDockTransportControlState(_ state: MPDClient.MPDStatus.State) {
    playPauseMenuItem.isEnabled = state.isOneOf([.playing, .paused, .stopped])
    stopMenuItem.isEnabled = state.isOneOf([.playing, .paused])
    nextTrackMenuItem.isEnabled = state.isOneOf([.playing, .paused])
    prevTrackMenuItem.isEnabled = state.isOneOf([.playing, .paused])

    if state.isOneOf([.paused, .stopped, .unknown]) {
      playPauseMenuItem.title = "Play"
    } else {
      playPauseMenuItem.title = "Pause"
    }
  }

  @objc func enableUpdateDatabaseMenuItem() {
    updateDatabaseMenuItem?.isEnabled = true
  }

  @IBAction func updateDatabase(_ sender: NSMenuItem) {
    App.store.dispatch(MPDUpdateDatabaseAction())
  }

  @IBAction func playPauseMenuAction(_ sender: NSMenuItem) {
    AppDelegate.mpdClient.playPause()
  }
  @IBAction func stopMenuAction(_ sender: NSMenuItem) {
    AppDelegate.mpdClient.stop()
  }
  @IBAction func nextTrackMenuAction(_ sender: NSMenuItem) {
    AppDelegate.mpdClient.nextTrack()
  }
  @IBAction func prevTrackMenuAction(_ sender: Any) {
    AppDelegate.mpdClient.prevTrack()
  }

  @IBOutlet weak var updateDatabaseMenuItem: NSMenuItem!

  @IBOutlet weak var playPauseMenuItem: NSMenuItem!
  @IBOutlet weak var stopMenuItem: NSMenuItem!
  @IBOutlet weak var nextTrackMenuItem: NSMenuItem!
  @IBOutlet weak var prevTrackMenuItem: NSMenuItem!
}

extension AppDelegate: StoreSubscriber {
  typealias StoreSubscriberStateType = Bool

  func newState(state: Bool) {
    updateDatabaseMenuItem.isEnabled = !state
  }
}
