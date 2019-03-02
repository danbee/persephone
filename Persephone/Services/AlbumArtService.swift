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
  let cacheQueue = DispatchQueue(label: "albumArtCacheQueue", attributes: .concurrent)

  func fetchAlbumArt(for album: AlbumItem, callback: @escaping (_ image: NSImage) -> Void) {
    cacheQueue.async {
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
        else { return false }

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
    if var urlComponents = URLComponents(string: "https://musicbrainz.org/ws/2/release/") {
      urlComponents.query = "query=artist:\(album.artist) AND release:\(album.title) AND country:US&limit=1&fmt=json"

      guard let searchURL = urlComponents.url
        else { return }

      let releaseTask = session.dataTask(with: searchURL) { data, response, error in
        if let _ = error {
          return
        }

        guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
            return
        }

        if let mimeType = httpResponse.mimeType, mimeType == "application/json",
          let data = data,
          let json = try? JSON(data: data) {

          let releaseId = json["releases"][0]["id"]

          let coverURL = URLComponents(string: "https://coverartarchive.org/release/\(releaseId)/front-500")

          let coverArtTask = self.session.dataTask(with: coverURL!.url!) { data, response, error in

            guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                return
            }

            if let mimeType = httpResponse.mimeType, mimeType == "image/jpeg",
              let data = data,
              let coverImage = NSImage(data: data) {

              self.cacheArtwork(for: album, data: data)
              callback(coverImage)
            }
          }

          coverArtTask.resume()
        }
      }
      releaseTask.resume()
    }
  }
}
