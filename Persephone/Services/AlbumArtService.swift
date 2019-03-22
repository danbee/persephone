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
  let album: AlbumItem
  
  let cachedArtworkSize = 180
  let cachedArtworkQuality: CGFloat = 0.5

  var session = URLSession(configuration: .default)
  let cacheQueue = DispatchQueue(label: "albumArtCacheQueue")

  init(album: AlbumItem) {
    self.album = album
  }

  func fetchAlbumArt(callback: @escaping (_ image: NSImage?) -> Void) {
    cacheQueue.async {
      firstly {
        self.getCachedArtwork()
      }.then { artwork -> Promise<NSImage?> in
        artwork.map(Promise.value) ?? self.cacheIfNecessary(self.getArtworkFromFilesystem())
      }.then { artwork -> Promise<NSImage?> in
        artwork.map(Promise.value) ?? self.cacheIfNecessary(self.getArtworkFromMusicBrainz().map(Optional.some))
      }.tap { result in
        switch result {
        case .fulfilled(nil), .rejected(MusicBrainzError.noArtworkAvailable):
          self.cacheArtwork(data: Data())
        default:
          break
        }
      }.recover { error in
        .value(nil)
      }.done(callback)
    }
  }

  func cacheIfNecessary(_ promise: Promise<NSImage?>) -> Promise<NSImage?> {
    return promise.get { image in
      if let data = image?.jpegData(compressionQuality: self.cachedArtworkQuality) {
        self.cacheArtwork(data: data)
      }
    }
  }
}


//getCachedArtwork
//  .then {
//    callback($0)
//  }
//  .catch {
//    getFileSystemArtwork
//  }
//  .then {
//    callback($0)
//  }
//  .catch {
//    getRemoteArtwork
//  }4
//  .then {
//    callback($0)
//  }
//
//// [() -> Promise<NSImage?>]
//// () -> Promise<NSImage>
