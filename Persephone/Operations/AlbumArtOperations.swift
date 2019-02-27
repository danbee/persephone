//
//  AlbumArtOperationQueue.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/26.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumArtOperations {
  static let shared = AlbumArtOperations()

  lazy var fetchAlbumArtQueue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "Fetch Album Art queue"
    queue.maxConcurrentOperationCount = 1
    return queue
  }()
}
