//
//  AlbumArtOperationQueue.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/26.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumArtQueue {
  static let shared = AlbumArtQueue()

  let queue = DispatchQueue(label: "AlbumArtQueue")
  var lastDispatchedTime = DispatchTime(uptimeNanoseconds: 0) - 1

  func addToQueue(workItem: DispatchWorkItem) {
    let dispatchTime = max(lastDispatchedTime + 1, DispatchTime(uptimeNanoseconds: 0))
    lastDispatchedTime = dispatchTime

    queue.asyncAfter(deadline: dispatchTime, execute: workItem)
  }
}
