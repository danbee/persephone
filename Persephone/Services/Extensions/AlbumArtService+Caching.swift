//
//  AlbumArtService+Caching.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/17.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

extension AlbumArtService {
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

  func cacheArtwork(for album: AlbumItem, data: Data?) {
    guard let bundleIdentifier = Bundle.main.bundleIdentifier,
      let cacheDir = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent(bundleIdentifier)
      else { return }

    let cacheFilePath = cacheDir.appendingPathComponent(album.hash).path

    FileManager.default.createFile(atPath: cacheFilePath, contents: data, attributes: nil)
  }
}
