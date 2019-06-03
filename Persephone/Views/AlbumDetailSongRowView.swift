//
//  AlbumDetailSongRowView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/22.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class AlbumDetailSongRowView: NSTableRowView {
  override func drawBackground(in dirtyRect: NSRect) {
    let borderPath = CGMutablePath()
    let startingPoint = CGPoint(x: dirtyRect.origin.x, y: dirtyRect.height)
    let endingPoint = CGPoint(x: dirtyRect.width, y: dirtyRect.height)

    borderPath.move(to: startingPoint)
    borderPath.addLine(to: endingPoint)

    let shapeLayer = CAShapeLayer()
    self.layer?.addSublayer(shapeLayer)

    shapeLayer.path = borderPath
    shapeLayer.strokeColor = NSColor.secondaryLabelColor.cgColor
    shapeLayer.lineWidth = 1
  }
}
