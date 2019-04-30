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
    App.store.subscribe(self) {
      $0.select { $0.playerState.currentSong }
    }
  }

  func notifyTrack(_ state: Song?) {
    guard let currentSong = state,
      let status = App.mpdClient.status,
      status.state == .playing
      else { return }

    let coverArtService = CoverArtService(song: currentSong)

    coverArtService.fetchBigCoverArt()
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
