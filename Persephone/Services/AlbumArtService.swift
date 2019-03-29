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

  var session = URLSession(configuration: .default)
  let artworkQueue = DispatchQueue(
    label: "albumArtQueue",
    qos: .background,
    attributes: .concurrent
  )

  init(song: Song) {
    self.song = song
    self.album = song.album
  }

  func fetchBigAlbumArt() -> Promise<NSImage?> {
    return firstly {
      self.getArtworkFromFilesystem()
    }.then { (artwork: NSImage?) -> Promise<NSImage?> in
      artwork.map(Promise.value) ?? self.getRemoteArtwork().map(Optional.some)
    }
  }

  func fetchAlbumArt() -> Guarantee<NSImage?> {
    return firstly {
      self.getCachedArtwork()
    }.then { (artwork: NSImage?) -> Promise<NSImage?> in
      artwork.map(Promise.value) ?? self.getArtworkFromFilesystem()
    }.then { (artwork: NSImage?) -> Promise<NSImage?> in
      artwork.map(Promise.value) ?? self.getRemoteArtwork().map(Optional.some)
    }.compactMap(on: artworkQueue) {
      return self.sizeAndCacheImage($0).map(Optional.some)
    }.recover { error in
      self.cacheArtwork(data: Data())
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
