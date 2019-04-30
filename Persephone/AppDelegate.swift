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

  func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
    let dockMenu = NSMenu()
    dockMenu.autoenablesItems = false

    guard let state = App.store.state.playerState.state else { return nil }

    if let currentSong = App.store.state.playerState.currentSong,
      state.isOneOf([.playing, .paused]) {

      let nowPlayingItem = NSMenuItem(title: "Now Playing", action: nil, keyEquivalent: "")
      let songItem = NSMenuItem(title: currentSong.title, action: nil, keyEquivalent: "")
      let albumItem = NSMenuItem(
        title: "\(currentSong.artist) — \(currentSong.album.title)",
        action: nil,
        keyEquivalent: ""
      )

      nowPlayingItem.isEnabled = false
      songItem.indentationLevel = 1
      songItem.isEnabled = false
      albumItem.indentationLevel = 1
      albumItem.isEnabled = false

      dockMenu.addItem(nowPlayingItem)
      dockMenu.addItem(songItem)
      dockMenu.addItem(albumItem)
      dockMenu.addItem(NSMenuItem.separator())
   }

    let playPauseMenuItem = NSMenuItem(
      title: state == .playing ? "Pause" : "Play",
      action: #selector(playPauseMenuAction),
      keyEquivalent: ""
    )
    let stopMenuItem = NSMenuItem(title: "Stop", action: #selector(stopMenuAction), keyEquivalent: "")
    let nextTrackMenuItem = NSMenuItem(title: "Next", action: #selector(nextTrackMenuAction), keyEquivalent: "")
    let prevTrackMenuItem = NSMenuItem(title: "Previous", action: #selector(prevTrackMenuAction), keyEquivalent: "")

    playPauseMenuItem.isEnabled = state.isOneOf([.playing, .paused, .stopped])
    stopMenuItem.isEnabled = state.isOneOf([.playing, .paused])
    nextTrackMenuItem.isEnabled = state.isOneOf([.playing, .paused])
    prevTrackMenuItem.isEnabled = state.isOneOf([.playing, .paused])

    dockMenu.addItem(playPauseMenuItem)
    dockMenu.addItem(stopMenuItem)
    dockMenu.addItem(nextTrackMenuItem)
    dockMenu.addItem(prevTrackMenuItem)

    return dockMenu
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

  @IBAction func playPauseMenuAction(_ sender: NSMenuItem) {
    App.store.dispatch(MPDPlayPauseAction())
  }
  @IBAction func stopMenuAction(_ sender: NSMenuItem) {
    App.store.dispatch(MPDStopAction())
  }
  @IBAction func nextTrackMenuAction(_ sender: NSMenuItem) {
    App.store.dispatch(MPDNextTrackAction())
  }
  @IBAction func prevTrackMenuAction(_ sender: Any) {
    App.store.dispatch(MPDPrevTrackAction())
  }

  @IBOutlet weak var updateDatabaseMenuItem: NSMenuItem!
}

extension AppDelegate: StoreSubscriber {
  typealias StoreSubscriberStateType = Bool

  func newState(state: Bool) {
    updateDatabaseMenuItem.isEnabled = !state
  }
}
