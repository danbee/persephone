//
//  NSImage.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

extension NSImage {
  static let playIcon = NSImage(named: "playButton")
  static let pauseIcon = NSImage(named: "pauseButton")
  static let queuePlayIcon = NSImage(named: "queuePlayButton")
  static let queuePauseIcon = NSImage(named: "queuePauseButton")
  
  static let defaultCoverArt = NSImage(named: "defaultCoverArt")
  
  static let speakerDisabled = NSImage(named: "speakerDisabled")
  static let speakerOff = NSImage(named: "speakerOff")
  static let speakerLow = NSImage(named: "speakerLow")
  static let speakerMid = NSImage(named: "speakerMid")
  static let speakerHigh = NSImage(named: "speakerHigh")
}
