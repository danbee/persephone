//
//  WindowController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/1/11.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
  enum TransportAction: Int {
    case prevTrack, playPause, stop, nextTrack
  }

  var state: MPDClient.Status.State?
  var totalTime: UInt?
  var elapsedTimeMs: UInt?
  var trackTimer: Timer?

  override func windowDidLoad() {
    super.windowDidLoad()
    window?.titleVisibility = .hidden

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(stateChanged(_:)),
      name: Notification.stateChanged,
      object: AppDelegate.mpdClient
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(timeChanged(_:)),
      name: Notification.timeChanged,
      object: AppDelegate.mpdClient
    )

    trackProgress.font = .timerFont
    trackRemaining.font = .timerFont
  }

  override func keyDown(with event: NSEvent) {
    switch event.keyCode {
    case NSEvent.keyCodeSpace:
      AppDelegate.mpdClient.playPause()
    default:
      nextResponder?.keyDown(with: event)
    }
  }

  @objc func stateChanged(_ notification: Notification) {
    guard let state = notification.userInfo?[Notification.stateKey] as? MPDClient.Status.State
      else { return }

    self.state = state

    setTransportControlState()
  }

  func setTransportControlState() {
    guard let state = state else { return }

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

  @objc func timeChanged(_ notification: Notification) {
    guard let totalTime = notification.userInfo?[Notification.totalTimeKey] as? UInt,
      let elapsedTimeMs = notification.userInfo?[Notification.elapsedTimeMsKey] as? UInt
      else { return }

    self.totalTime = totalTime
    self.elapsedTimeMs = elapsedTimeMs

    setTrackProgressControls()
  }

  func setTrackProgressControls() {
    guard let totalTime = totalTime,
      let elapsedTimeMs = elapsedTimeMs
      else { return }

    trackProgressBar.isEnabled = [.playing, .paused].contains(state)
    trackProgressBar.integerValue = 0
    trackProgressBar.maxValue = Double(totalTime * 1000)

    if state == .playing {
      trackTimer?.invalidate()

      trackTimer = Timer.scheduledTimer(
        timeInterval: 0.25,
        target: self,
        selector: #selector(updateProgress(_:)),
        userInfo: [
          "startTime": CACurrentMediaTime(),
          "startElapsed": Double(elapsedTimeMs) / 1000
        ],
        repeats: true
      )
    } else {
      trackTimer?.invalidate()

      trackProgressBar.integerValue = Int(elapsedTimeMs)
      setTimeElapsed()
      setTimeRemaining()
   }
  }

  @objc func updateProgress(_ timer: Timer) {
    let currentTime = CACurrentMediaTime()

    guard let userInfo = timer.userInfo as? Dictionary<String, Any>,
      let startTime = userInfo["startTime"] as? Double,
      let startElapsed = userInfo["startElapsed"] as? Double
      else { return }

    let timeDiff = currentTime - startTime
    let newElapsedTimeMs = (startElapsed + timeDiff) * 1000

    self.elapsedTimeMs = UInt(newElapsedTimeMs)
    trackProgressBar.integerValue = Int(newElapsedTimeMs)

    setTimeElapsed()
    setTimeRemaining()
  }

  func setTimeElapsed() {
    guard let elapsedTimeMs = elapsedTimeMs else { return }

    let time = Time(timeInSeconds: Int(elapsedTimeMs) / 1000)

    trackProgress.stringValue = time.formattedTime
  }

  func setTimeRemaining() {
    guard let elapsedTimeMs = elapsedTimeMs,
      let totalTime = totalTime
      else { return }

    let time = Time(timeInSeconds: -(Int(totalTime) - Int(elapsedTimeMs) / 1000))

    trackRemaining.stringValue = time.formattedTime
  }

  // TODO: Refactor this using a gesture recognizer
  @IBAction func changeTrackProgress(_ sender: NSSlider) {
    guard let event = NSApplication.shared.currentEvent else {
      return
    }

    switch event.type {
    case .leftMouseDown:
      trackTimer?.invalidate()
    case .leftMouseDragged:
      self.elapsedTimeMs = UInt(sender.integerValue)

      setTimeElapsed()
      setTimeRemaining()
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
}
