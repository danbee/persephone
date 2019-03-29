//
//  AlbumArtService+Remote.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/17.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import SwiftyJSON
import PromiseKit
import PMKFoundation

extension AlbumArtService {
  enum MusicBrainzError: Error {
    case noArtworkAvailable
  }

  func getRemoteArtwork() -> Promise<NSImage> {
    return Promise { seal in
      artworkQueue.async {
        let albumArtWorkItem = DispatchWorkItem {
          self.getArtworkFromMusicBrainz().pipe(to: seal.resolve)
        }

        AlbumArtQueue.shared.addToQueue(workItem: albumArtWorkItem)
      }
    }
  }

  func getArtworkFromMusicBrainz() -> Promise<NSImage> {
    var search = URLComponents(string: "https://musicbrainz.org/ws/2/release/")!
    search.query = "query=artist:\(album.artist) AND release:\(album.title) AND country:US&limit=1&fmt=json"

    return firstly {
      URLSession.shared.dataTask(.promise, with: search.url!).validate()
    }.compactMap {
      JSON($0.data)
    }.compactMap {
      $0["releases"][0]["id"].string
    }.compactMap {
      URLComponents(string: "https://coverartarchive.org/release/\($0)/front-500")?.url
    }.then { (url: URL?) -> Promise<(data: Data, response: URLResponse)> in
      return URLSession.shared.dataTask(.promise, with: url!).validate()
    }.compactMap {
      NSImage(data: $0.data)?.toFitBox(
        size: NSSize(width: self.cachedArtworkSize, height: self.cachedArtworkSize)
      )
    }.recover { error -> Promise<NSImage> in
      if case PMKHTTPError.badStatusCode(404, _, _) = error {
        throw MusicBrainzError.noArtworkAvailable
      } else {
        throw error
      }
    }
  }
}
