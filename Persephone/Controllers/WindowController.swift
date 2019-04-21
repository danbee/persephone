//
//  WindowController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/1/11.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import ReSwift

class WindowController: NSWindowController, StoreSubscriber {
  typealias StoreSubscriberStateType = AppState

  enum TransportAction: Int {
    case prevTrack, playPause, stop, nextTrack
  }

  var state: MPDClient.MPDStatus.State?
  var trackTimer: Timer?

  override func windowDidLoad() {
    super.windowDidLoad()
    window?.titleVisibility = .hidden

    // TODO: We will want to filter this subscribe later
    AppDelegate.store.subscribe(self)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(startDatabaseUpdatingIndicator),
      name: Notification.databaseUpdateStarted,
      object: AppDelegate.mpdClient
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(stopDatabaseUpdatingIndicator),
      name: Notification.databaseUpdateFinished,
      object: AppDelegate.mpdClient
    )

    trackProgress.font = .timerFont
    trackRemaining.font = .timerFont
  }

  func newState(state: WindowController.StoreSubscriberStateType) {
    self.state = state.playerState.state

    DispatchQueue.main.async {
      self.setTransportControlState(state.playerState)
      self.setTrackProgressControls(state.playerState)
    }
  }

  override func keyDown(with event: NSEvent) {
    switch event.keyCode {
    case NSEvent.keyCodeSpace:
      AppDelegate.mpdClient.playPause()
    default:
      nextResponder?.keyDown(with: event)
    }
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

  @objc func startDatabaseUpdatingIndicator() {
    databaseUpdatingIndicator.startAnimation(self)
  }

  @objc func stopDatabaseUpdatingIndicator() {
    databaseUpdatingIndicator.stopAnimation(self)
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

  // TODO: Refactor this using a gesture recognizer
  @IBAction func changeTrackProgress(_ sender: NSSlider) {
    guard let event = NSApplication.shared.currentEvent
      else { return }

    switch event.type {
    case .leftMouseDown:
      trackTimer?.invalidate()
    case .leftMouseDragged:
      AppDelegate.store.dispatch(
        UpdateElapsedTimeAction(elapsedTimeMs: UInt(sender.integerValue))
      )
    case .leftMouseUp:
      let seekTime = Float(sender.integerValue) / 1000

      AppDelegate.mpdClient.seekCurrentSong(timeInSeconds: seekTime)
    default:
      break
    }
  }

  @IBAction func handleTransportControl(_ sender: NSSegmentedControl) {
    guard let transportAction = TransportAction(rawValue: sender.selectedSegment)
      else { return }

    switch transportAction {
    case .prevTrack:
      AppDelegate.mpdClient.prevTrack()
    case .playPause:
      AppDelegate.mpdClient.playPause()
    case .stop:
      AppDelegate.mpdClient.stop()
    case .nextTrack:
      AppDelegate.mpdClient.nextTrack()
    }
  }

  @IBOutlet var transportControls: NSSegmentedCell!
  
  @IBOutlet var trackProgress: NSTextField!
  @IBOutlet var trackProgressBar: NSSlider!
  @IBOutlet var trackRemaining: NSTextField!
  @IBOutlet var databaseUpdatingIndicator: NSProgressIndicator!
}
