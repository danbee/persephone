//
//  NSImage.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

extension NSImage {
  static let playIcon = NSImage(named: "playButton")
  static let pauseIcon = NSImage(named: "pauseButton")

  static let defaultCoverArt = NSImage(named: "blankAlbum")

  func toFitBox(size: NSSize) -> NSImage {
    let newImage = NSImage(size: size)
    newImage.lockFocus()
    self.draw(in: newImage.alignmentRect)
    newImage.unlockFocus()
    return newImage
  }

  func jpegData(compressionQuality: CGFloat) -> Data? {
    guard let image = cgImage(forProposedRect: nil, context: nil, hints: nil)
      else { return nil }

    let bitmapImageRep = NSBitmapImageRep(cgImage: image)

    return bitmapImageRep.representation(
      using: .jpeg,
      properties: [.compressionFactor: compressionQuality]
    )
  }
}
