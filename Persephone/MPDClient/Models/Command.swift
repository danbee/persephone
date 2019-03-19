//
//  Command.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension MPDClient {
  enum Command {
    // Transport commands
    case prevTrack
    case nextTrack
    case playPause
    case stop
    case seekCurrentSong

    // Status commands
    case fetchStatus

    // Queue commands
    case fetchQueue
    case playTrack

    // Album commands
    case fetchAllAlbums
    case playAlbum
    case getAlbumURI
  }
}
