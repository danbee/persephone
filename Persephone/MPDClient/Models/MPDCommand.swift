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
    case connect
    case disconnect
    
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
    case moveSongInQueue
    case addSongToQueue
    case addAlbumToQueue

    // Artist commands
    case fetchAllArtists

    // Album commands
    case fetchAlbums
    case playAlbum
    case getAlbumFirstSong
    case getAlbumSongs
  }
}
