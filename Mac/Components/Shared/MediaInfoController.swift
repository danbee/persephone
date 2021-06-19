//
//  MediaInfoController.swift
//  Persephone
//
//  Created by Alan Harper on 18/11/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import Foundation
import ReSwift
import MediaPlayer
import Kingfisher

class MediaInfoController {
  init() {
    App.store.subscribe(self) {
      $0.select { $0.playerState }
    }
  }

  func notifyTrack(_ song: Song) {
    let provider = MPDAlbumArtImageDataProvider(
      songUri: song.mpdSong.uriString,
      cacheKey: song.album.hash
    )

    let infoCenter = MPNowPlayingInfoCenter.default()

    var nowPlayingInfo = [
      MPMediaItemPropertyTitle: song.title,
      MPMediaItemPropertyArtist: song.artist,
      MPMediaItemPropertyAlbumArtist: song.album.artist,
      MPMediaItemPropertyAlbumTitle: song.album.title,
      MPMediaItemPropertyPlaybackDuration: NSNumber(value: song.duration.timeInSeconds),
      MPNowPlayingInfoPropertyMediaType: NSNumber(value: MPNowPlayingInfoMediaType.audio.rawValue),
      MPNowPlayingInfoPropertyIsLiveStream: NSNumber(value: false),
    ] as [String : Any]

    if let elapsedTime = App.store.state.playerState.elapsedTimeMs {
      nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] =
        NSNumber(value: elapsedTime / 1000)
    }

    if #available(OSX 10.13.2, *) {
      _ = KingfisherManager.shared.retrieveImage(
        with: .provider(provider),
        options: [
          .processor(DownsamplingImageProcessor(size: .notificationCoverSize)),
          .scaleFactor(2),
        ]
      ) { result in
        switch result {
        case .success(let value):
          let artwork = MPMediaItemArtwork.init(boundsSize: CGSize(width: 100.0, height: 100.0)) { (size: CGSize) in value.image }
          nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
          infoCenter.nowPlayingInfo = nowPlayingInfo
        case .failure:
          infoCenter.nowPlayingInfo = nowPlayingInfo
          break
        }
      }
    } else {
      infoCenter.nowPlayingInfo = nowPlayingInfo
    }
  }
}

extension MediaInfoController: StoreSubscriber {
  typealias StoreSubscriberStateType = PlayerState?

  func newState(state: StoreSubscriberStateType) {
    guard let song = state?.currentSong else { return }

    notifyTrack(song)
  }
}
