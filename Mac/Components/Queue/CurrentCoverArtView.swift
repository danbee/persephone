//
//  CurrentCoverArtView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/27.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import ReSwift
import Kingfisher

class CurrentCoverArtView: NSImageView {
  required init?(coder: NSCoder) {
    super.init(coder: coder)

    App.store.subscribe(self) {
      $0.select { $0.playerState.currentSong }
    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(didReloadAlbumArt), name: .didReloadAlbumArt, object: nil)
  }
  
  @objc func didReloadAlbumArt() {
    guard let song = App.store.state.playerState.currentSong
      else { return }
    
    setSongImage(song)
  }

  func setSongImage(_ song: Song) {
    let provider = AlbumArtImageDataProvider(
      songUri: song.mpdSong.uriString,
      cacheKey: song.album.hash
    )

    kf.setImage(
      with: .provider(provider),
      placeholder: NSImage.defaultCoverArt,
      options: [
        .processor(DownsamplingImageProcessor(size: .currentlyPlayingCoverSize)),
        .scaleFactor(2),
      ]
    )
  }
}

extension CurrentCoverArtView: StoreSubscriber {
  typealias StoreSubscriberStateType = Song?

  func newState(state: Song?) {
    guard let song = state else {
      image = .defaultCoverArt
      return
    }
    
    setSongImage(song)
  }
}
