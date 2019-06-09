//
//  QueueView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/09.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class QueueView: NSOutlineView {
  override func menu(for event: NSEvent) -> NSMenu? {
    let point = convert(event.locationInWindow, from: nil)

    let currentRow = row(at: point)

    if currentRow > 0 {
      return super.menu(for: event)
    } else {
      return nil
    }
  }
}
