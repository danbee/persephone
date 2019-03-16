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

    // Status commands
    case .fetchStatus:
      sendRunStatus()
    case .fetchQueue:
      sendFetchQueue()

    // Album commands
    case .fetchAllAlbums:
      allAlbums()
    case .playAlbum:
      guard let album = userData["album"] as? Album else { return }
      sendPlayAlbum(album)
    case .getAlbumURI:
      guard let album = userData["album"] as? Album else { return }
      _ = getAlbumURI(for: album)
    }
  }
}
