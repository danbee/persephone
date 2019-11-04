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

    case .setShuffleState:
      guard let shuffleState = userData["shuffleState"] as? Bool
        else { return }
      sendShuffleState(shuffleState: shuffleState)

    case .setRepeatState:
      guard let repeatState = userData["repeatState"] as? Bool
        else { return }
      sendRepeatState(repeatState: repeatState)

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
    case .clearQueue:
      sendClearQueue()
    case .replaceQueue:
      guard let songs = userData["songs"] as? [MPDSong]
        else { return }
      sendReplaceQueue(songs)
    case .appendSong:
      guard let song = userData["song"] as? MPDSong
        else { return }
      sendAppendSong(song)
    case .removeSong:
      guard let queuePos = userData["queuePos"] as? Int
        else { return }
      sendRemoveSong(at: queuePos)

    case .moveSongInQueue:
      guard let oldQueuePos = userData["oldQueuePos"] as? Int,
        let newQueuePos = userData["newQueuePos"] as? Int
        else { return }
      sendMoveSongInQueue(at: oldQueuePos, to: newQueuePos)

    case .addSongToQueue:
      guard let songUri = userData["uri"] as? String,
        let queuePos = userData["queuePos"] as? Int
        else { return }
      sendAddSongToQueue(uri: songUri, at: queuePos)

    case .addAlbumToQueue:
      guard let album = userData["album"] as? MPDAlbum,
        let queuePos = userData["queuePos"] as? Int
        else { return }
      sendAddAlbumToQueue(album: album, at: queuePos)

    // Artist commands
    case .fetchAllArtists:
      allArtists()

    // Album commands
    case .fetchAllAlbums:
      allAlbums(filter: "")
    case .playAlbum:
      guard let album = userData["album"] as? MPDAlbum else { return }
      sendPlayAlbum(album)
    case .getAlbumFirstSong:
      guard let album = userData["album"] as? MPDAlbum,
        let callback = userData["callback"] as? (MPDSong?) -> Void
        else { return }

      albumFirstSong(for: album, callback: callback)

    case .getAlbumSongs:
      guard let album = userData["album"] as? MPDAlbum,
        let callback = userData["callback"] as? ([MPDSong]) -> Void
        else { return }

      albumSongs(for: album, callback: callback)
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
