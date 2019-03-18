//
//  AlbumArtService+Filesystem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/17.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

extension AlbumArtService {
  func getArtworkFromFilesystem(
    for album: AlbumItem,
    callback: @escaping (_ image: NSImage) -> Void
    ) {
    let coverArtFilenames = [
      "folder.jpg",
      "cover.jpg",
      "\(album.artist) - \(album.title).jpg"
    ]

    let callback = { (_ albumURI: String?) in
      guard let albumURI = albumURI
        else { return }

      let musicDir = self.preferences.expandedMpdLibraryDir
      let fullAlbumURI = "\(musicDir)/\(albumURI)"

      for coverArtFilename in coverArtFilenames {
        let coverArtURI = "\(fullAlbumURI)/\(coverArtFilename)"

        if let image = self.tryImage(coverArtURI) {
          self.cacheArtwork(
            for: album,
            data: image.jpegData(compressionQuality: self.cachedArtworkQuality)
          )
          callback(image)
          break
        }
      }
    }

    AppDelegate.mpdClient.getAlbumURI(
      for: album.album,
      callback: callback
    )
  }

  func tryImage(_ filePath: String) -> NSImage? {
    if FileManager.default.fileExists(atPath: filePath),
      let data = FileManager.default.contents(atPath: filePath),
      let image = NSImage(data: data) {

      let imageThumb = image.toFitBox(
        size: NSSize(width: self.cachedArtworkSize, height: self.cachedArtworkSize)
      )

      return imageThumb
    } else {
      return nil
    }
  }
}
