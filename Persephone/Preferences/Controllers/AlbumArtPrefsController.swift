//
//  AlbumArtPrefsController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/23.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumArtPrefsController: NSViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    preferredContentSize = NSMakeSize(view.frame.size.width, view.frame.size.height)
  }
}
