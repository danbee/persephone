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
    guard command == .connect || isConnected else { return }

    switch command {
      
    case .connect:
      guard let host = userData["host"] as? String,
        let port = userData["port"] as? Int
        else { return }
      createConnection(host: host, port: port)
    case .disconnect:
      freeConnection()

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
      
    case .setVolume:
      guard let volume = userData["volume"] as? Int
        else { return }
      sendSetVolume(to: volume)

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
    case .fetchAlbums:
      guard let filter = userData["filter"] as? String else { return }
      albums(filter: filter)
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
      
      // Song commands
      case .fetchAlbumArt:
        guard let songUri = userData["songUri"] as? String,
          let offset = userData["offset"] as? Int32,
          let callback = userData["callback"] as? (Data?) -> Void
          else { return }
      
        let imageData = userData["imageData"] as? Data? ?? nil
        
        sendFetchAlbumArt(
          forUri: songUri,
          imageData: imageData,
          offset: offset,
          callback: callback
        )
    }
    
  }

  func enqueueCommand(
    command: MPDCommand,
    priority: BlockOperation.QueuePriority = .normal,
    forceIdle: Bool = false,
    userData: Dictionary<String, Any> = [:]
  ) {
    guard isConnected else { return }

    noIdle()

    let commandOperation = BlockOperation() { [unowned self] in
      self.sendCommand(command: command, userData: userData)
  
      if self.checkError() {
        self.idle(forceIdle)
      }
    }

    commandOperation.queuePriority = priority
    commandQueue.addOperation(commandOperation)
  }
}
