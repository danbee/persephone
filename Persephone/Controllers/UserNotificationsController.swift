//
//  UserNotificationsController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/27.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import ReSwift

class UserNotificationsController {
  init() {
    AppDelegate.store.subscribe(self) {
      $0.select { $0.playerState.currentSong }
    }
  }

  func notifyTrack(_ state: Song?) {
    guard let currentSong = state,
      let status = AppDelegate.mpdClient.status,
      status.state == .playing
      else { return }

    let albumArtService = AlbumArtService(song: currentSong)

    albumArtService.fetchBigAlbumArt()
      .done() {
        SongNotifierService(song: currentSong, image: $0)
          .deliver()
      }
      .cauterize()
  }
}

extension UserNotificationsController: StoreSubscriber {
  typealias StoreSubscriberStateType = Song?

  func newState(state: Song?) {
    notifyTrack(state)
  }
}
