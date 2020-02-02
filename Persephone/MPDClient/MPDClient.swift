//
//  MPDClient.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/1/25.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

class MPDClient {
  var connectionOperation: BlockOperation!

  var delegate: MPDClientDelegate?

  var connection: OpaquePointer?
  var isConnected: Bool = false
  var isIdle: Bool = false
  var status: MPDStatus?
  var queue: [MPDSong] = []

  let commandQueue = OperationQueue()
  
  let idleLock = NSLock()

  init(withDelegate delegate: MPDClientDelegate?) {
    commandQueue.maxConcurrentOperationCount = 1
    self.delegate = delegate
  }
}
