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
    command: MPDCommand,
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

    // Database commands
    case .updateDatabase:
      sendUpdateDatabase()

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
      guard let album = userData["album"] as? MPDAlbum else { return }
      sendPlayAlbum(album)
    case .getAlbumFirstSong:
      guard let album = userData["album"] as? MPDAlbum,
        let callback = userData["callback"] as? (MPDSong?) -> Void
        else { return }
      albumFirstSong(for: album, callback: callback)
    }
  }

  func enqueueCommand(
    command: MPDCommand,
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
