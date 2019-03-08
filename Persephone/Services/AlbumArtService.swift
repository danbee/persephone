//
//  AlbumArtService.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/23.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import SwiftyJSON
import PromiseKit
import PMKFoundation

class AlbumArtService: NSObject {
  static var shared = AlbumArtService()
  var session = URLSession(configuration: .default)
  let albumArtQueue = DispatchQueue(label: "albumArtCacheQueue", attributes: .concurrent)

  func fetchAlbumArt(for album: AlbumItem, callback: @escaping (_ image: NSImage) -> Void) {
    albumArtQueue.async {
      if !self.getCachedArtwork(for: album, callback: callback) {
        self.getRemoteArtwork(for: album, callback: callback)
      }
    }
  }

  func getCachedArtwork(for album: AlbumItem, callback: @escaping (_ image: NSImage) -> Void) -> Bool {
    guard let bundleIdentifier = Bundle.main.bundleIdentifier,
      let cacheDir = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent(bundleIdentifier)
      else { return false }

    let cacheFilePath = cacheDir.appendingPathComponent(album.hash).path

    if FileManager.default.fileExists(atPath: cacheFilePath) {
      guard let data = FileManager.default.contents(atPath: cacheFilePath),
        let image = NSImage(data: data)
        else { return true }

      callback(image)

      return true
    } else {
      return false
    }
  }

  func cacheArtwork(for album: AlbumItem, data: Data) {
    guard let bundleIdentifier = Bundle.main.bundleIdentifier,
      let cacheDir = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent(bundleIdentifier)
      else { return }

    let cacheFilePath = cacheDir.appendingPathComponent(album.hash).path

    FileManager.default.createFile(atPath: cacheFilePath, contents: data, attributes: nil)
  }

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
      self.cacheArtwork(for: album, data: $0.data)
      return NSImage(data: $0.data)
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
