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
  typealias StoreSubscriberStateType = PlayerState

  enum TransportAction: Int {
    case prevTrack, playPause, stop, nextTrack
  }

  var state: MPDClient.MPDStatus.State?
  var trackTimer: Timer?

  override func windowDidLoad() {
    super.windowDidLoad()
    window?.titleVisibility = .hidden

    AppDelegate.store.subscribe(self) {
      (subscription: Subscription<AppState>) -> Subscription<PlayerState> in

      subscription.select { state in state.playerState }
    }

    trackProgress.font = .timerFont
    trackRemaining.font = .timerFont
  }

  func newState(state: StoreSubscriberStateType) {
    self.state = state.state

    DispatchQueue.main.async {
      self.setTransportControlState(state)
      self.setTrackProgressControls(state)
      self.setDatabaseUpdatingIndicator(state)
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

  func setDatabaseUpdatingIndicator(_ playerState: PlayerState) {
    if playerState.databaseUpdating {
      startDatabaseUpdatingIndicator()
    } else {
      stopDatabaseUpdatingIndicator()
    }
  }

  func startDatabaseUpdatingIndicator() {
    databaseUpdatingIndicator.startAnimation(self)
  }

  func stopDatabaseUpdatingIndicator() {
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
