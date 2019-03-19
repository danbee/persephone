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
  func getRemoteArtwork(for album: AlbumItem, callback: @escaping (_ image: NSImage) -> Void) {
    let albumArtWorkItem = DispatchWorkItem() {
      self.getArtworkFromMusicBrainz(for: album, callback: callback)
    }

    AlbumArtQueue.shared.addToQueue(workItem: albumArtWorkItem)
  }

  func getArtworkFromMusicBrainz(for album: AlbumItem, callback: @escaping (_ image: NSImage) -> Void) {
    guard var urlComponents = URLComponents(string: "https://musicbrainz.org/ws/2/release/")
      else { return }

    urlComponents.query = "query=artist:\(album.artist) AND release:\(album.title) AND country:US&limit=1&fmt=json"

    guard let searchURL = urlComponents.url
      else { return }

    URLSession.shared.dataTask(.promise, with: searchURL).validate()
      .compactMap {
        JSON($0.data)
      }.compactMap {
        $0["releases"][0]["id"].string
      }.compactMap {
        URLComponents(string: "https://coverartarchive.org/release/\($0)/front-500")
      }.then { (urlComponents: URLComponents?) -> Promise<(data: Data, response: URLResponse)> in
        let url = urlComponents!.url
        return URLSession.shared.dataTask(.promise, with: url!).validate()
      }.compactMap {
        NSImage(data: $0.data)?.toFitBox(
          size: NSSize(width: self.cachedArtworkSize, height: self.cachedArtworkSize)
        )
      }.compactMap {
        self.cacheArtwork(
          for: album,
          data: $0.jpegData(compressionQuality: self.cachedArtworkQuality)
        )
        return $0
      }.done {
        callback($0)
      }.catch {
        if let httpError = $0 as? PMKHTTPError {
          switch httpError {
          case let .badStatusCode(statusCode, _, _):
            switch statusCode {
            case 404:
              self.cacheArtwork(for: album, data: Data())
            default:
              self.getRemoteArtwork(for: album, callback: callback)
            }
          }
        }
      }
  }
}
