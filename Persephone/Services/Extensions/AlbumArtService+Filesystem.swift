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

    let musicDir = self.preferences.expandedMpdLibraryDir
    let songPath = self.songPath()

    return Promise { seal in
      artworkQueue.async {
        let image = coverArtFilenames
          .lazy
          .map { "\(musicDir)/\(songPath)/\($0)" }
          .compactMap(self.tryImage)
          .first

        seal.fulfill(image)
      }
    }
  }

  func songPath() -> String {
    return song
      .mpdSong
      .uriString
      .split(separator: "/")
      .dropLast()
      .joined(separator: "/")
  }

  func tryImage(_ filePath: String) -> NSImage? {
    guard let data = FileManager.default.contents(atPath: filePath),
      let image = NSImage(data: data)
      else { return nil }

    return image
  }
}
