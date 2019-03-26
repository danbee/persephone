//
//  AlbumArtService+Filesystem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/17.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import PromiseKit

extension AlbumArtService {
  func getArtworkFromFilesystem() -> Promise<NSImage?> {
    let coverArtFilenames = [
      "folder.jpg",
      "cover.jpg",
      "\(album.artist) - \(album.title).jpg"
    ]

    return getAlbumURI().map { albumURI in
      let musicDir = self.preferences.expandedMpdLibraryDir

      return coverArtFilenames
        .lazy
        .map { "\(musicDir)/\(albumURI)/\($0)" }
        .compactMap(self.tryImage)
        .first
    }
  }

  func getAlbumURI() -> Promise<String> {
    return Promise { seal in
      AppDelegate.mpdClient.getAlbumURI(for: album.album, callback: seal.fulfill)
    }
      .compactMap { $0 }
  }

  func tryImage(_ filePath: String) -> NSImage? {
    guard let data = FileManager.default.contents(atPath: filePath),
      let image = NSImage(data: data)
      else { return nil }

    let imageThumb = image.toFitBox(
      size: NSSize(width: self.cachedArtworkSize, height: self.cachedArtworkSize)
    )

    return imageThumb
  }
}
