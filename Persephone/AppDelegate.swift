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

  @IBOutlet weak var mainWindowMenuItem: NSMenuItem!
  @IBOutlet weak var updateDatabaseMenuItem: NSMenuItem!
  @IBOutlet weak var playSelectedSongMenuItem: NSMenuItem!
  @IBOutlet weak var playSelectedSongNextMenuItem: NSMenuItem!
  @IBOutlet weak var addSelectedSongToQueueMenuItem: NSMenuItem!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    mediaKeyTap = MediaKeyTap(delegate: self)
    mediaKeyTap?.start()

    App.store.subscribe(self) {
      $0.select {
        $0.uiState
      }
    }
    
    instantiateControllers()
    connectToMPDServer()
  }

  func connectToMPDServer() {
    App.mpdServerController.connect()
  }

  func instantiateControllers() {
    _ = App.userNotificationsController
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    App.mpdClient.disconnect()
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

  func setMainWindowStateMenuItem(state: MainWindowState) {
    switch state {
    case .open: mainWindowMenuItem.state = .on
    case .closed: mainWindowMenuItem.state = .off
    case .minimised: mainWindowMenuItem.state = .mixed
    }
  }

  func setSongMenuItemsState(selectedSong: Song?) {
    playSelectedSongMenuItem.isEnabled = selectedSong != nil
    playSelectedSongNextMenuItem.isEnabled = selectedSong != nil
    addSelectedSongToQueueMenuItem.isEnabled = selectedSong != nil
  }

  func handle(mediaKey: MediaKey, event: KeyEvent) {
    switch mediaKey {
    case .playPause:
      App.mpdClient.playPause()
    case .next, .fastForward:
      App.mpdClient.nextTrack()
    case .previous, .rewind:
      App.mpdClient.prevTrack()
    }
  }

  @IBAction func updateDatabase(_ sender: NSMenuItem) {
    App.mpdClient.updateDatabase()
  }

  @IBAction func playPauseMenuAction(_ sender: NSMenuItem) {
    App.mpdClient.playPause()
  }
  @IBAction func stopMenuAction(_ sender: NSMenuItem) {
    App.mpdClient.stop()
  }
  @IBAction func nextTrackMenuAction(_ sender: NSMenuItem) {
    App.mpdClient.nextTrack()
  }
  @IBAction func prevTrackMenuAction(_ sender: NSMenuItem) {
    App.mpdClient.prevTrack()
  }

  @IBAction func removeQueueSongMenuAction(_ sender: NSMenuItem) {
    guard let queueItem = App.store.state.uiState.selectedQueueItem
      else { return }

    App.mpdClient.removeSong(at: queueItem.queuePos)
    App.store.dispatch(SetSelectedQueueItem(selectedQueueItem: nil))
  }
  @IBAction func clearQueueMenuAction(_ sender: NSMenuItem) {
    let alert = NSAlert()
    alert.alertStyle = .warning
    alert.messageText = "Are you sure you want to clear the queue?"
    alert.informativeText = "You can’t undo this action."
    alert.addButton(withTitle: "Clear Queue")
    alert.addButton(withTitle: "Cancel")

    let result = alert.runModal()

    if result == .alertFirstButtonReturn {
      App.mpdClient.clearQueue()
    }
  }

  @IBAction func playSelectedSongAction(_ sender: NSMenuItem) {
    guard let song = App.store.state.uiState.selectedSong
      else { return }

    let queueLength = App.store.state.queueState.queue.count
    App.mpdClient.appendSong(song.mpdSong)
    App.mpdClient.playTrack(at: queueLength)
  }
  @IBAction func playSelectedSongNextAction(_ sender: NSMenuItem) {
    let queuePos = App.store.state.queueState.queuePos

    guard let song = App.store.state.uiState.selectedSong,
      queuePos > -1
      else { return }

    App.mpdClient.addSongToQueue(songUri: song.mpdSong.uriString, at: queuePos + 1)
  }
  @IBAction func addSelectedSongToQueueAction(_ sender: NSMenuItem) {
    guard let song = App.store.state.uiState.selectedSong
      else { return }

    App.mpdClient.appendSong(song.mpdSong)
  }
}

extension AppDelegate: StoreSubscriber {
  typealias StoreSubscriberStateType = UIState

  func newState(state: UIState) {
    updateDatabaseMenuItem.isEnabled = !state.databaseUpdating
    setMainWindowStateMenuItem(state: state.mainWindowState)
    setSongMenuItemsState(selectedSong: state.selectedSong)
  }
}
