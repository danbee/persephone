//
//  CoverArtService.swift
//  Persephone
//
//  Created by Daniel Barber on 2/3/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import Foundation
import PromiseKit
import Kingfisher

struct CoverArtService {
  let song: Song
  let provider: MPDAlbumArtImageDataProvider
  
  init(song: Song) {
    self.song = song

    provider = MPDAlbumArtImageDataProvider(
      songUri: song.mpdSong.uriString,
      cacheKey: song.album.hash
    )
  }
  
  func refreshAlbumListArt() -> Promise<Any> {
    return Promise<Any> { seal in
      _ = KingfisherManager.shared.retrieveImage(
        with: .provider(provider),
        options: [
          .forceRefresh,
          .memoryCacheExpiration(.never),
          .processor(DownsamplingImageProcessor(size: .albumListCoverSize)),
          .scaleFactor(2),
        ]
      ) { result in
        seal.fulfill(result)
      }
    }
  }
  
  func refreshCurrentlyPlayingArt() -> Promise<Any> {
    return Promise<Any> { seal in
      _ = KingfisherManager.shared.retrieveImage(
        with: .provider(provider),
        options: [
          .forceRefresh,
          .memoryCacheExpiration(.never),
          .processor(DownsamplingImageProcessor(size: .currentlyPlayingCoverSize)),
          .scaleFactor(2),
          .callbackQueue(.mainAsync)
        ]
      ) { result in
        seal.fulfill(result)
      }
    }
  }
  
  func refreshQueueSongArt() -> Promise<Any> {
    return Promise<Any> { seal in
      _ = KingfisherManager.shared.retrieveImage(
        with: .provider(provider),
        options: [
          .forceRefresh,
          .memoryCacheExpiration(.never),
          .processor(DownsamplingImageProcessor(size: .queueSongCoverSize)),
          .scaleFactor(2),
        ]
      ) { result in
        seal.fulfill(result)
      }
    }
  }
  
  func refresh(callback: @escaping () -> Void?) {
    _ = firstly {
      when(fulfilled: refreshAlbumListArt(), refreshQueueSongArt(), refreshCurrentlyPlayingArt())
    }.done { _, _, _ in
      NotificationCenter.default.post(name: .didReloadAlbumArt, object: nil)
      callback()
    }
  }
}
