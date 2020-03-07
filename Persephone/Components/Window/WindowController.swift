//
//  WindowController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/1/11.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import ReSwift

class WindowController: NSWindowController {
  enum TransportAction: Int {
    case prevTrack, playPause, stop, nextTrack
  }

  var state: MPDClient.MPDStatus.State?
  var trackTimer: Timer?

  @IBOutlet var transportControls: NSSegmentedCell!

  @IBOutlet var trackProgress: NSTextField!
  @IBOutlet var trackProgressBar: NSSlider!
  @IBOutlet var trackRemaining: NSTextField!
  @IBOutlet var databaseUpdatingIndicator: NSProgressIndicator!

  @IBOutlet var shuffleState: NSButton!
  @IBOutlet var repeatState: NSButton!

  @IBOutlet var volumeState: NSButton!

  @IBOutlet weak var searchQuery: NSSearchField!
  
  override func windowDidLoad() {
    super.windowDidLoad()
    window?.titleVisibility = .hidden
    window?.isExcludedFromWindowsMenu = true

    App.store.subscribe(self) {
      $0.select {
        ($0.serverState, $0.playerState, $0.uiState)
      }
    }

    App.store.dispatch(MainWindowDidOpenAction())
    
    NotificationCenter.default.addObserver(self, selector: #selector(willDisconnect), name: .willDisconnect, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(reportError), name: .didRaiseError, object: nil)

    trackProgress.font = .timerFont
    trackRemaining.font = .timerFont
  }

  func setTransportControlState(_ state: PlayerState) {
    guard let state = state.state else { return }

    transportControls.setEnabled(state.isOneOf([.playing, .paused]), forSegment: 0)
    transportControls.setEnabled(state.isOneOf([.playing, .paused, .stopped]), forSegment: 1)
    transportControls.setEnabled(state.isOneOf([.playing, .paused]), forSegment: 2)
    transportControls.setEnabled(state.isOneOf([.playing, .paused]), forSegment: 3)

    if state.isOneOf([.paused, .stopped, .unknown]) {
      transportControls.setImage(.playIcon, forSegment: 1)
    } else {
      transportControls.setImage(.pauseIcon, forSegment: 1)
    }
  }

  func setShuffleRepeatState(
    _ serverState: ServerState,
    _ playerState: PlayerState
  ) {
    shuffleState.isEnabled = serverState.connected
    repeatState.isEnabled = serverState.connected
    shuffleState.state = playerState.shuffleState ? .on : .off
    repeatState.state = playerState.repeatState ? .on : .off
  }
  
  func setSearchState(_ serverState: ServerState) {
    searchQuery.isEnabled = serverState.connected
  }

  func setTrackProgressControls(_ playerState: PlayerState) {
    guard let state = playerState.state,
      let totalTime = playerState.totalTime,
      let elapsedTimeMs = playerState.elapsedTimeMs
      else { return }

    trackProgressBar.isEnabled = state.isOneOf([.playing, .paused])
    trackProgressBar.maxValue = Double(totalTime * 1000)
    trackProgressBar.integerValue = Int(elapsedTimeMs)

    setTimeElapsed(elapsedTimeMs)
    setTimeRemaining(elapsedTimeMs, totalTime * 1000)
  }

  func setDatabaseUpdatingIndicator(_ uiState: UIState) {
    if uiState.databaseUpdating {
      databaseUpdatingIndicator.startAnimation(self)
    } else {
      databaseUpdatingIndicator.stopAnimation(self)
    }
  }

  func setTimeElapsed(_ elapsedTimeMs: UInt?) {
    guard let elapsedTimeMs = elapsedTimeMs else { return }

    let time = Time(timeInSeconds: Int(elapsedTimeMs) / 1000)

    trackProgress.stringValue = time.formattedTime
  }

  func setTimeRemaining(_ elapsedTimeMs: UInt?, _ totalTime: UInt?) {
    guard let elapsedTimeMs = elapsedTimeMs,
      let totalTime = totalTime
      else { return }

    let time = Time(
      timeInSeconds: -(Int(totalTime) - Int(elapsedTimeMs)) / 1000
    )

    trackRemaining.stringValue = time.formattedTime
  }
  
  func setVolumeControlIcon(_ state: PlayerState) {
    volumeState.isEnabled = state.volume != -1

    switch state.volume {
    case -1:
      volumeState.image = .speakerDisabled
    case 0..<5:
      volumeState.image = .speakerOff
    case 5..<40:
      volumeState.image = .speakerLow
    case 40..<70:
      volumeState.image = .speakerMid
    case 70...100:
      volumeState.image = .speakerHigh
    default:
      break
    }
  }
    
  @objc func willDisconnect() {
    DispatchQueue.main.async {
      App.store.dispatch(ResetStatusAction())
      self.searchQuery.stringValue = ""
    }
  }
  
  @objc func reportError(_ notification: NSNotification) {
    guard let error = notification.object as? MPDClient.MPDError
      else { return }

    DispatchQueue.main.async {
      guard let window = NSApplication.shared.mainWindow ?? self.window
        else { return }

      let alert = NSAlert(error: error)
      alert.messageText = error.message

      alert.alertStyle = error.recovered ? .warning : .critical
      
      switch error.mpdError {
      case MPD_ERROR_MALFORMED,
           MPD_ERROR_ARGUMENT:
        alert.informativeText = "Please check the mpd log for more details."
      case MPD_ERROR_SYSTEM,
           MPD_ERROR_TIMEOUT:
        alert.informativeText = "Is the mpd server running?"
      case MPD_ERROR_RESOLVER:
        alert.informativeText = "Check your network connection."
      default:
        break;
      }
      
      if !error.recovered {
        alert.addButton(withTitle: "Reconnect")
        alert.addButton(withTitle: "Dismiss")
      }

      alert.beginSheetModal(for: window) { response in
        switch response {
        case .alertFirstButtonReturn:
          if !error.recovered {
            App.mpdServerController.connect()
          }
        default:
          break
        }
      }
    }
  }

  // TODO: Refactor this using a gesture recognizer
  @IBAction func changeTrackProgress(_ sender: NSSlider) {
    guard let event = NSApplication.shared.currentEvent
      else { return }

    switch event.type {
    case .leftMouseDown:
      trackTimer?.invalidate()
    case .leftMouseDragged:
      App.store.dispatch(
        UpdateElapsedTimeAction(elapsedTimeMs: UInt(sender.integerValue))
      )
    case .leftMouseUp:
      let seekTime = Float(sender.integerValue) / 1000

      App.mpdClient.seekCurrentSong(timeInSeconds: seekTime)
    default:
      break
    }
  }

  @IBAction func handleTransportControl(_ sender: NSSegmentedControl) {
    guard let transportAction = TransportAction(rawValue: sender.selectedSegment)
      else { return }

    switch transportAction {
    case .prevTrack:
      App.mpdClient.prevTrack()
    case .playPause:
      App.mpdClient.playPause()
    case .stop:
      App.mpdClient.stop()
    case .nextTrack:
      App.mpdClient.nextTrack()
    }
  }

  @IBAction func handleShuffleButton(_ sender: NSButton) {
    App.mpdClient.setShuffleState(shuffleState: sender.state == .on)
  }

  @IBAction func handleRepeatButton(_ sender: NSButton) {
    App.mpdClient.setRepeatState(repeatState: sender.state == .on)
  }

  @IBAction func handleSearchQuery(_ sender: NSSearchField) {
    App.store.dispatch(SetSearchQuery(searchQuery: sender.stringValue))
  }
  
  @IBAction func showVolumeControl(_ sender: NSButton) {
    VolumeControlView.popover.contentViewController = VolumeControlView.shared
    VolumeControlView.popover.behavior = .transient
    VolumeControlView.popover.show(
      relativeTo: sender.bounds,
      of: sender,
      preferredEdge: .maxY
    )
  }
}

extension WindowController: NSWindowDelegate {
  func windowWillClose(_ notification: Notification) {
    App.store.dispatch(MainWindowDidCloseAction())
  }

  func windowWillMiniaturize(_ notification: Notification) {
    App.store.dispatch(MainWindowDidMinimizeAction())
  }

  func windowDidDeminiaturize(_ notification: Notification) {
    App.store.dispatch(MainWindowDidOpenAction())
  }
}

extension WindowController: StoreSubscriber {
  typealias StoreSubscriberStateType = (
    serverState: ServerState, playerState: PlayerState, uiState: UIState
  )

  func newState(state: StoreSubscriberStateType) {
    DispatchQueue.main.async {
      self.setTransportControlState(state.playerState)
      self.setShuffleRepeatState(state.serverState, state.playerState)
      self.setSearchState(state.serverState)
      self.setTrackProgressControls(state.playerState)
      self.setDatabaseUpdatingIndicator(state.uiState)
      self.setVolumeControlIcon(state.playerState)
    }
  }
}
