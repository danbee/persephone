//
//  AlbumArtService.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/23.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import PromiseKit

class AlbumArtService {
  var preferences = Preferences()
  let song: Song
  let album: Album

  let cachedArtworkSize = 180
  let cachedArtworkQuality: CGFloat = 0.5

  let bigArtworkSize = 600

  var session = URLSession(configuration: .default)
  let artworkQueue = DispatchQueue(label: "albumArtQueue", qos: .background)

  init(song: Song) {
    self.song = song
    self.album = song.album
  }

  func fetchBigAlbumArt() -> Promise<NSImage?> {
    return firstly {
      self.getArtworkFromFilesystem()
    }.then { (image: NSImage?) -> Promise<NSImage?> in
      image.map(Promise.value) ?? self.getRemoteArtwork()
    }.compactMap(on :artworkQueue) { image in
      if self.fileSystemArtworkFilePath() != nil {
        let sizedImage = image?.toFitBox(
          size: NSSize(width: self.bigArtworkSize, height: self.bigArtworkSize)
        )
        self.saveArtworkToFilesystem(data: sizedImage?.jpegData(compressionQuality: self.cachedArtworkQuality))
        return sizedImage
      } else {
        return image
      }
    }
  }

  func fetchAlbumArt() -> Guarantee<NSImage?> {
    return firstly {
      self.getCachedArtwork()
    }.then { (artwork: NSImage?) -> Promise<NSImage?> in
      artwork.map(Promise.value) ?? self.getArtworkFromFilesystem()
    }.then { (artwork: NSImage?) -> Promise<NSImage?> in
      artwork.map(Promise.value) ?? self.getRemoteArtwork()
    }.compactMap(on: artworkQueue) {
      return self.sizeAndCacheImage($0).map(Optional.some)
    }.recover { error in
      switch error {
      case RemoteArtworkError.noArtworkAvailable:
        self.cacheArtwork(data: Data())
      default:
        break
      }
      return .value(nil)
    }
  }

  func sizeAndCacheImage(_ image: NSImage?) -> NSImage? {
    switch image {
    case nil:
      self.cacheArtwork(data: Data())
      return image
    case let image:
      if self.isArtworkCached() {
        return image
      } else {
        let sizedImage = image?.toFitBox(
          size: NSSize(width: self.cachedArtworkSize, height: self.cachedArtworkSize)
        )
        self.cacheArtwork(data: sizedImage?.jpegData(compressionQuality: self.cachedArtworkQuality))
        return sizedImage
      }
    }
  }
}
