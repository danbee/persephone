//
//  MPDAlbumArtImageDataProvider.swift
//  Persephone
//
//  Created by Daniel Barber on 2/1/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import Foundation
import Kingfisher

public struct MPDAlbumArtImageDataProvider: ImageDataProvider {
  let songUri: String

  init(songUri: String, cacheKey: String) {
    self.songUri = songUri
    self.cacheKey = cacheKey
  }

  public var cacheKey: String

  public func data(handler: @escaping (Result<Data, Error>) -> Void) {
    App.mpdClient.fetchAlbumArt(songUri: songUri, imageData: nil) { imageData in
      guard let imageData = imageData
        else { return }

      handler(.success(imageData))
    }
  }

  public var contentURL: String? {
    return songUri
  }
}

public func AlbumArtImageDataProvider(songUri: String, cacheKey: String) -> ImageDataProvider {
    if App.store.state.preferencesState.fetchArtworkFromCustomURL, let url = App.store.state.preferencesState.customArtworkURL {
        return CustomURLAlbumArtImageDataProvider(baseURL: url, songUri: songUri, cacheKey: cacheKey)
    } else {
        return MPDAlbumArtImageDataProvider(songUri: songUri, cacheKey: cacheKey)
    }
}
