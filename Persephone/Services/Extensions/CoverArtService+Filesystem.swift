//
//  CoverArtService+Filesystem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/17.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import PromiseKit

extension CoverArtService {
  var coverArtFilenames: [String] {
    return [
      "folder.jpg",
      "cover.jpg",
      "\(album.artist) - \(album.title).jpg"
    ]
  }

  var musicDir: String {
    return App.store.state.preferencesState.expandedMpdLibraryDir
  }

  func getArtworkFromFilesystem() -> Promise<NSImage?> {
    return Promise { seal in
      CoverArtService.coverArtQueue.async {
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
        atPath: "\(self.musicDir)/\(self.path)/\(artworkFileName)",
        contents: data,
        attributes: nil
      )
    }
  }

  func fileSystemArtworkFilePath() -> String? {
    let musicDir = App.store.state.preferencesState.expandedMpdLibraryDir

    return self.coverArtFilenames
      .lazy
      .map { "\(musicDir)/\(self.path)/\($0)" }
      .first {
        FileManager.default.fileExists(atPath: $0)
      }
  }

  func tryImage(_ filePath: String) -> NSImage? {
    guard let data = FileManager.default.contents(atPath: filePath),
      let image = NSImage(data: data)
      else { return nil }

    return image
  }
}
