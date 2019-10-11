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
  var deltaX: CGFloat = 0
  var deltaY: CGFloat = 0

  override func mouseDown(with event: NSEvent) {
    nextResponder?.mouseDown(with: event)
  }

  override func mouseDragged(with event: NSEvent) {
    deltaX = deltaX + event.deltaX
    deltaY = deltaY + event.deltaY

    if (deltaX > 5 || deltaX < -5 || deltaY > 5 || deltaY < -5) {
      dragging = true
    }
    
    nextResponder?.mouseDragged(with: event)
  }

  override func mouseUp(with event: NSEvent) {
    deltaX = 0
    deltaY = 0

    if dragging {
      dragging = false
      nextResponder?.mouseUp(with: event)
    } else {
      super.mouseDown(with: event)
      super.mouseUp(with: event)
    }
  }
}
