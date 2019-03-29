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
  var coverArtFilenames: [String] {
    return [
      "folder.jpg",
      "cover.jpg",
      "\(album.artist) - \(album.title).jpg"
    ]
  }

  var musicDir: String {
    return self.preferences.expandedMpdLibraryDir
  }

  func getArtworkFromFilesystem() -> Promise<NSImage?> {
    return Promise { seal in
      artworkQueue.async {
        guard let artworkPath = self.fileSystemArtworkFilePath()
          else { seal.fulfill(nil); return }

        let image = self.tryImage(artworkPath)

        seal.fulfill(image)
      }
    }
  }

  func saveArtworkToFilesystem(data: Data?) {
    let artworkFileName = coverArtFilenames.first!

    if self.fileSystemArtworkFilePath() == nil {
      FileManager.default.createFile(
        atPath: "\(self.musicDir)/\(self.songPath)/\(artworkFileName)",
        contents: data,
        attributes: nil
      )
    }
  }

  func fileSystemArtworkFilePath() -> String? {
    let musicDir = self.preferences.expandedMpdLibraryDir

    return self.coverArtFilenames
      .lazy
      .map { "\(musicDir)/\(self.songPath)/\($0)" }
      .first {
        FileManager.default.fileExists(atPath: $0)
      }
  }

  var songPath: String {
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
