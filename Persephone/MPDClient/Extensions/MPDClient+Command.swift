//
//  CommandQueue.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension MPDClient {
  func sendCommand(
    command: Command,
    userData: Dictionary<String, Any> = [:]
  ) {
    switch command {

    // Transport commands
    case .prevTrack:
      sendPreviousTrack()
    case .nextTrack:
      sendNextTrack()
    case .stop:
      sendStop()
    case .playPause:
      sendPlay()
    case .seekCurrentSong:
      guard let timeInSeconds = userData["timeInSeconds"] as? Float
        else { return }
      sendSeekCurrentSong(timeInSeconds: timeInSeconds)

    // Status commands
    case .fetchStatus:
      sendRunStatus()

    // Queue commands
    case .fetchQueue:
      sendFetchQueue()
    case .playTrack:
      guard let queuePos = userData["queuePos"] as? Int
        else { return }
      sendPlayTrack(at: queuePos)

    // Album commands
    case .fetchAllAlbums:
      allAlbums()
    case .playAlbum:
      guard let album = userData["album"] as? Album else { return }
      sendPlayAlbum(album)
    case .getAlbumURI:
      guard let album = userData["album"] as? Album,
        let callback = userData["callback"] as? (String?) -> Void
        else { return }
      albumURI(for: album, callback: callback)
    }
  }

  func enqueueCommand(
    command: Command,
    priority: BlockOperation.QueuePriority = .normal,
    userData: Dictionary<String, Any> = [:]
  ) {
    guard isConnected else { return }

    noIdle()

    let commandOperation = BlockOperation() { [unowned self] in
      self.sendCommand(command: command, userData: userData)

      self.idle()
    }
    commandOperation.queuePriority = priority
    commandQueue.addOperation(commandOperation)
  }
}
