//
//  CustomURLAlbumArtImageDataProvider.swift
//  Persephone
//
//  Created by Diego Torres on 07.11.20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import Foundation
import Kingfisher

public struct CustomURLAlbumArtImageDataProvider: ImageDataProvider {
  let songUri: String
  let baseURL: URL

  init(baseURL: URL, songUri: String, cacheKey: String) {
    self.songUri = songUri
    self.cacheKey = cacheKey
    self.baseURL = baseURL
  }

  public var cacheKey: String

  public func data(handler: @escaping (Result<Data, Error>) -> Void) {
    let task = URLSession.shared.dataTask(with: baseURL.appendingPathComponent(songUri)) { (data, response, error) in
        let result = Result<Data, Error> {
            if let error = error { throw error }
            guard let data = data else { throw URLError(.badServerResponse) }
            return data
        }
        handler(result)
    }
    task.resume()
  }

  public var contentURL: String? {
    return songUri
  }
}
