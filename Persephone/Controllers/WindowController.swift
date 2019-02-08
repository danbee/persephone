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

  let playIcon = NSImage(named: NSImage.Name("playButton"))
  let pauseIcon = NSImage(named: NSImage.Name("pauseButton"))

  override func windowDidLoad() {
    super.windowDidLoad()
    window?.titleVisibility = .hidden

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(stateChanged(_:)),
      name: Notification.stateChanged,
      object: AppDelegate.mpdClient
    )
  }

  @objc func stateChanged(_ notification: Notification) {
    guard let state = notification.userInfo?[Notification.stateKey] as? MPDClient.Status.State
      else { return }

    setTransportControlState(state)
  }

  func setTransportControlState(_ state: MPDClient.Status.State) {
    transportControls.setEnabled(state.isOneOf([.playing, .paused]), forSegment: 0)
    transportControls.setEnabled(state.isOneOf([.playing, .paused, .stopped]), forSegment: 1)
    transportControls.setEnabled(state.isOneOf([.playing, .paused]), forSegment: 2)
    transportControls.setEnabled(state.isOneOf([.playing, .paused]), forSegment: 3)

    if state.isOneOf([.paused, .stopped, .unknown]) {
      transportControls.setImage(playIcon, forSegment: 1)
    } else {
      transportControls.setImage(pauseIcon, forSegment: 1)
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
}
