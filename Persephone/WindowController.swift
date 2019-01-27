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
    case prevTrack = 0
    case playPause = 1
    case stop = 2
    case nextTrack = 3
  }
  var mpdClient: MPDClient?

  override func windowDidLoad() {
    super.windowDidLoad()
    window?.titleVisibility = .hidden

    mpdInit()
  }

  func mpdInit() {
    mpdClient = MPDClient()
    mpdClient?.connect()
  }

  @IBAction func handleTransportControl(_ sender: NSSegmentedControl) {
    guard let transportAction = TransportAction(rawValue: sender.selectedSegment)
      else { return }

    switch transportAction {
    case .prevTrack:
      mpdClient?.prevTrack()
    case .playPause:
      mpdClient?.playPause()
    case .stop:
      mpdClient?.stop()
    case .nextTrack:
      mpdClient?.nextTrack()
    }
  }
}
