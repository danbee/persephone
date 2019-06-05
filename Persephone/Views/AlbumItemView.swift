//
//  AlbumItemView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/17.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class AlbumItemView: NSView {
  required init?(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }

  @IBOutlet var imageView: NSImageView!
}
