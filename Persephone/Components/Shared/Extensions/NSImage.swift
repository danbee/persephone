//
//  NSImage.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

extension NSImage {
  static let playIcon = NSImage(named: "playButton")
  static let pauseIcon = NSImage(named: "pauseButton")
  static let queuePlayIcon = NSImage(named: "queuePlayButton")
  static let queuePauseIcon = NSImage(named: "queuePauseButton")
  
  static let defaultCoverArt = NSImage(named: "defaultCoverArt")

  func toFitBox(size: NSSize) -> NSImage {
    var newSize: NSSize = NSSize.zero
    let aspectRatio = self.size.width / self.size.height
    let boxAspectRatio = size.width / size.height

    if aspectRatio > boxAspectRatio {
      newSize = NSSize(width: size.width, height: size.width / aspectRatio)
    } else {
      newSize = NSSize(width: size.height * aspectRatio, height: size.height)
    }

    let newImage = NSImage(size: newSize)
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
