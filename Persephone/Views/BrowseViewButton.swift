//
//  BrowseViewButton.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/9/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class BrowseViewButton: NSButton {
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    // Drawing code here.
    self.layer?.cornerRadius = 4
    self.layer?.masksToBounds = true
    if #available(OSX 10.14, *) {
      self.layer?.backgroundColor = NSColor.controlAccentColor.cgColor
    } else {
      // Fallback on earlier versions
    }
  }
}
