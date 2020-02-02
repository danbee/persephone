//
//  CoverArtService.swift
//  Persephone
//
//  Created by Daniel Barber on 2/3/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import Foundation
import Kingfisher

struct CoverArtService {
  let song: Song
  
  func refresh(callback: @escaping () -> Void?) {
    let provider = MPDAlbumArtImageDataProvider(
      songUri: song.mpdSong.uriString,
      cacheKey: song.album.hash
    )
    
    _ = KingfisherManager.shared.retrieveImage(
      with: .provider(provider),
      options: [
        .forceRefresh,
        .memoryCacheExpiration(.never),
        .processor(DownsamplingImageProcessor(size: .albumListCoverSize)),
        .scaleFactor(2),
      ]
    ) { _ in
      callback()
    }
    
    _ = KingfisherManager.shared.retrieveImage(
      with: .provider(provider),
      options: [
        .forceRefresh,
        .memoryCacheExpiration(.never),
        .processor(DownsamplingImageProcessor(size: .currentlyPlayingCoverSize)),
        .scaleFactor(2),
        .callbackQueue(.mainAsync)
      ]
    ) { _ in }

    _ = KingfisherManager.shared.retrieveImage(
      with: .provider(provider),
      options: [
        .forceRefresh,
        .memoryCacheExpiration(.never),
        .processor(DownsamplingImageProcessor(size: .queueSongCoverSize)),
        .scaleFactor(2),
      ]
    ) { _ in
      NotificationCenter.default.post(name: .didReloadAlbumArt, object: nil)
    }
  }
}
