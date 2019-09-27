//
//  ArtistViewItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/9/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class ArtistViewItem: NSViewController {
  var artist: String?

  @IBOutlet var artistName: NSTextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.
  }

  func setArtist(_ artist: String) {
    self.artist = artist

    artistName.stringValue = artist
  }
}
