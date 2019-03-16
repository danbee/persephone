//
//  PreferencesWindowController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/09.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSWindowDelegate {
  override func windowDidLoad() {
    super.windowDidLoad()
  }

  func windowShouldClose(_ sender: NSWindow) -> Bool {
    self.window?.orderOut(sender)
    return false
  }
}
