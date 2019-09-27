//
//  BrowseController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/9/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class BrowseController: NSViewController {
  @IBOutlet var artistsButton: NSButton!
  @IBOutlet var albumsButton: NSButton!

  @IBOutlet var browseTabView: NSTabView!

  @IBAction func switchToTab(_ sender: NSButton) {
    artistsButton.state = .off
    albumsButton.state = .off

    switch sender.identifier?.rawValue {
    case "artists":
      artistsButton.state = .on
      browseTabView.selectTabViewItem(at: 0)
    case "albums":
      albumsButton.state = .on
      browseTabView.selectTabViewItem(at: 1)
    default:
      return
    }
  }
}
