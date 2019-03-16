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
  var delegate: MPDClientDelegate?

  var connection: OpaquePointer?
  var isConnected: Bool = false
  var isIdle: Bool = false
  var status: Status?
  var queue: [Song] = []

  let commandQueue = OperationQueue()
  var commandsQueued: UInt = 0

  enum Command {
    case prevTrack, nextTrack, playPause, stop,
      fetchStatus, fetchQueue, fetchAllAlbums,
      playAlbum, getAlbumURI
  }

  init(withDelegate delegate: MPDClientDelegate?) {
    commandQueue.maxConcurrentOperationCount = 1
    self.delegate = delegate
  }

  func queueCommand(
    command: Command,
    priority: BlockOperation.QueuePriority = .normal,
    userData: Dictionary<String, Any> = [:]
  ) {
    guard isConnected else { return }

    noIdle()
    let commandOperation = BlockOperation() { [unowned self] in
      self.commandsQueued -= 1
      self.sendCommand(command: command, userData: userData)
    }
    commandOperation.queuePriority = priority
    commandsQueued += 1
    commandQueue.addOperation(commandOperation)
    idle()
  }
}
