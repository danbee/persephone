//
//  NSView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/18.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

extension NSView {
  func image() -> NSImage {
    layoutSubtreeIfNeeded()
    let imageRepresentation = bitmapImageRepForCachingDisplay(in: frame)!
    cacheDisplay(in: frame, to: imageRepresentation)
    return NSImage(cgImage: imageRepresentation.cgImage!, size: frame.size)
  }
}
