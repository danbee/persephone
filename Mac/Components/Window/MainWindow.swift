//
//  MainWindow.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/22.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class MainWindow: NSWindow {
  override func sendEvent(_ event: NSEvent) {
    guard let responder = firstResponder else { return }

    if event.type == .keyDown &&
      doesNotRequireSpace(responder) {

      switch event.keyCode {
      case NSEvent.keyCodeSpace:
        App.mpdClient.playPause()
      default:
        super.sendEvent(event)
      }
    } else {
      super.sendEvent(event)
    }
  }
  
  func doesNotRequireSpace(_ responder: NSResponder) -> Bool {
    return !responder.isKind(of: NSText.self) &&
      !responder.isKind(of: NSButton.self)
  }
}
