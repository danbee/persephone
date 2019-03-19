//
//  AlbumArtService.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/23.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumArtService: NSObject {
  var preferences = Preferences()
  
  let cachedArtworkSize = 180
  let cachedArtworkQuality: CGFloat = 0.5

  static var shared = AlbumArtService()

  var session = URLSession(configuration: .default)
  let cacheQueue = DispatchQueue(label: "albumArtCacheQueue", attributes: .concurrent)

  func fetchAlbumArt(for album: AlbumItem, callback: @escaping (_ image: NSImage) -> Void) {
    cacheQueue.async { [unowned self] in
      if !self.getCachedArtwork(for: album, callback: callback) {
        self.getArtworkFromFilesystem(for: album, callback: callback)
      }
    }
  }
}
