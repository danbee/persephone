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
  let cache = ImageCache.default

  init() {
    App.store.subscribe(self) {
      $0.select { $0.playerState.currentSong }
    }
  }

  func notifyTrack(_ state: Song?) {
    guard let currentSong = state,
      let coverArtFilePath = currentSong.album.coverArtFilePath,
      let status = App.mpdClient.status,
      status.state == .playing
      else { return }

    let imageURL = URL(fileURLWithPath: coverArtFilePath)
    let provider = LocalFileImageDataProvider(fileURL: imageURL)
    _ = KingfisherManager.shared.retrieveImage(
      with: .provider(provider),
      options: [
        .processor(DownsamplingImageProcessor(size: NSSize(width: 180, height: 180))),
        .scaleFactor(2),
      ]
    ) { result in
      switch result {
      case .success(let value):
        SongNotifierService(song: currentSong, image: value.image)
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
