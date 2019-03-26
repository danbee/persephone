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
      let cacheFilePath = AlbumArtService.cacheDir.appendingPathComponent(album.hash).path
      let data = FileManager.default.contents(atPath: cacheFilePath)
      let image = data.flatMap(NSImage.init(data:))

      seal.fulfill(image)
    }
  }

  func cacheArtwork(data: Data?) {
    guard let bundleIdentifier = Bundle.main.bundleIdentifier,
      let cacheDir = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent(bundleIdentifier)
      else { return }

    let cacheFilePath = cacheDir.appendingPathComponent(album.hash).path

    if !FileManager.default.fileExists(atPath: cacheFilePath) {
      FileManager.default.createFile(atPath: cacheFilePath, contents: data, attributes: nil)
    }
  }
}
