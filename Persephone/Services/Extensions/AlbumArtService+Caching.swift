//
//  AlbumArtService+Caching.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/17.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import PromiseKit

extension AlbumArtService {
  static let cacheDir = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(Bundle.main.bundleIdentifier!)

  func getCachedArtwork() -> Promise<NSImage?> {
    return Promise { seal in
      artworkQueue.async {
        if self.isArtworkCached() {
          let cacheFilePath = AlbumArtService.cacheDir.appendingPathComponent(self.album.hash).path
          let data = FileManager.default.contents(atPath: cacheFilePath)
          let image = NSImage(data: data ?? Data()) ?? NSImage.defaultCoverArt

          seal.fulfill(image)
        } else {
          seal.fulfill(nil)
        }
      }
    }
  }

  func cacheArtwork(data: Data?) {
    artworkQueue.async {
      guard let bundleIdentifier = Bundle.main.bundleIdentifier,
        let cacheDir = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
          .appendingPathComponent(bundleIdentifier)
        else { return }

      let cacheFilePath = cacheDir.appendingPathComponent(self.album.hash).path

      if !self.isArtworkCached() {
        FileManager.default.createFile(atPath: cacheFilePath, contents: data, attributes: nil)
      }
    }
  }

  func isArtworkCached() -> Bool {
    let cacheFilePath = AlbumArtService.cacheDir.appendingPathComponent(album.hash).path

    return FileManager.default.fileExists(atPath: cacheFilePath)
  }
}
