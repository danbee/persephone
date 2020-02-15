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
