//
//  WindowController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/1/11.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
  let mpdClient = MPDClient.shared

  enum TransportAction: Int {
    case prevTrack = 0
    case playPause = 1
    case stop = 2
    case nextTrack = 3
  }

  override func windowDidLoad() {
    super.windowDidLoad()
    window?.titleVisibility = .hidden

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(stateChanged(_:)),
      name: MPDClient.stateChanged,
      object: mpdClient
    )
  }

  @objc func stateChanged(_ notification: Notification) {
    guard let state = notification.userInfo?[MPDClient.stateKey] as? MPDClient.State
      else { return }

    stateLabel.stringValue = "\(state)".localizedCapitalized
  }

  @IBAction func handleTransportControl(_ sender: NSSegmentedControl) {
    guard let transportAction = TransportAction(rawValue: sender.selectedSegment)
      else { return }

    switch transportAction {
    case .prevTrack:
      mpdClient.prevTrack()
    case .playPause:
      mpdClient.playPause()
    case .stop:
      mpdClient.stop()
    case .nextTrack:
      mpdClient.nextTrack()
    }
  }

  @IBOutlet var stateLabel: NSTextField!
}
