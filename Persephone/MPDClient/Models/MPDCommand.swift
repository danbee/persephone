//
//  Command.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension MPDClient {
  enum MPDCommand {
    // Transport commands
    case prevTrack
    case nextTrack
    case playPause
    case stop
    case seekCurrentSong

    case setShuffleState
    case setRepeatState

    // Database commands
    case updateDatabase

    // Status commands
    case fetchStatus

    // Queue commands
    case fetchQueue
    case playTrack
    case clearQueue
    case replaceQueue
    case appendSong
    case removeSong

    // Album commands
    case fetchAllAlbums
    case playAlbum
    case getAlbumFirstSong
    case getAlbumSongs
  }
}
