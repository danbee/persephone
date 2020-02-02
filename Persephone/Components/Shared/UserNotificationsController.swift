//
//  UserNotificationsController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/27.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import ReSwift
import Kingfisher

class UserNotificationsController {
  init() {
    App.store.subscribe(self) {
      $0.select { $0.playerState.currentSong }
    }
  }

  func notifyTrack(_ state: Song?) {
    guard let song = state,
      let status = App.mpdClient.status,
      status.state == .playing
      else { return }
    
    let provider = MPDAlbumArtImageDataProvider(
      songUri: song.mpdSong.uriString,
      cacheKey: song.album.hash
    )

    _ = KingfisherManager.shared.retrieveImage(
      with: .provider(provider),
      options: [
        .processor(DownsamplingImageProcessor(size: .notificationCoverSize)),
        .scaleFactor(2),
      ]
    ) { result in
      switch result {
      case .success(let value):
        SongNotifierService(song: song, image: value.image)
          .deliver()
      case .failure:
        break
      }
    }
  }
}

extension UserNotificationsController: StoreSubscriber {
  typealias StoreSubscriberStateType = Song?

  func newState(state: Song?) {
    notifyTrack(state)
  }
}
