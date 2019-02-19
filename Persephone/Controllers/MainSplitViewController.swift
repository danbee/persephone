//
//  MainSplitViewController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/22.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {
  override func keyDown(with event: NSEvent) {
    switch event.keyCode {
    case NSEvent.keyCodeSpace:
      nextResponder?.keyDown(with: event)
    default:
      super.keyDown(with: event)
    }
  }
}
