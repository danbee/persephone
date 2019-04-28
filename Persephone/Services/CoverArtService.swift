//
//  CoverArtService.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/23.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import PromiseKit

class CoverArtService {
  var preferences = Preferences()
  let song: Song
  let album: Album

  let cachedArtworkSize = 180
  let cachedArtworkQuality: CGFloat = 0.5

  let bigArtworkSize = 600

  var session = URLSession(configuration: .default)
  let coverArtQueue = DispatchQueue(label: "coverArtQueue", qos: .utility)

  init(song: Song) {
    self.song = song
    self.album = song.album
  }

  func fetchBigCoverArt() -> Promise<NSImage?> {
    return firstly {
      self.getArtworkFromFilesystem()
    }.then { (image: NSImage?) -> Promise<NSImage?> in
      image.map(Promise.value) ?? self.getRemoteArtwork()
    }.recover { (_) -> Guarantee<NSImage?> in
      return .value(nil)
    }
  }

  func fetchCoverArt() -> Guarantee<NSImage?> {
    return firstly {
      self.getCachedArtwork()
    }.then { (artwork: NSImage?) -> Promise<NSImage?> in
      artwork.map(Promise.value) ?? self.getArtworkFromFilesystem()
    }.then { (artwork: NSImage?) -> Promise<NSImage?> in
      artwork.map(Promise.value) ?? self.getRemoteArtwork()
    }.compactMap(on: coverArtQueue) {
      return self.sizeAndCacheImage($0).map(Optional.some)
    }.recover { _ in
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
