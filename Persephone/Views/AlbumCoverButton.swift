//
//  AlbumCoverButton.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class AlbumCoverButton: NSButton {
  var dragging = false

  override func mouseDown(with event: NSEvent) {
    nextResponder?.mouseDown(with: event)
  }

  override func mouseDragged(with event: NSEvent) {
    dragging = true
    nextResponder?.mouseDragged(with: event)
  }

  override func mouseUp(with event: NSEvent) {
    if dragging {
      dragging = false
      nextResponder?.mouseUp(with: event)
    } else {
      super.mouseDown(with: event)
      super.mouseUp(with: event)
    }
  }
}
