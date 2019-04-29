//
//  CoverArtService+Caching.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/17.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import PromiseKit

extension CoverArtService {
  static let cacheDir = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(Bundle.main.bundleIdentifier!)

  func getCachedArtwork() -> Promise<NSImage?> {
    return Promise { seal in
      coverArtQueue.async {
        if self.isArtworkCached() {
          let cacheFilePath = CoverArtService.cacheDir.appendingPathComponent(self.album.hash).path
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
    coverArtQueue.async {
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
    let cacheFilePath = CoverArtService.cacheDir.appendingPathComponent(album.hash).path

    return FileManager.default.fileExists(atPath: cacheFilePath)
  }
}
