//
//  QueueSongCoverView.swift
//  Persephone
//
//  Created by Daniel Barber on 1/20/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import AppKit
import Kingfisher

class QueueSongCoverView: NSTableCellView {
  @IBOutlet var queueSongCover: NSImageView!
  @IBOutlet var queueSongIcon: NSImageView!
  
  let playingFilters = [
    CIFilter(name: "CIExposureAdjust", parameters: ["inputEV": -2])!
  ]
  
  var isPlaying: Bool = false
  
  override func viewDidMoveToSuperview() {
    super.viewDidMoveToSuperview()
    
    queueSongCover.wantsLayer = true
    queueSongCover.layer?.backgroundColor = CGColor.black
    queueSongCover.layer?.cornerRadius = 2
    queueSongCover.layer?.borderWidth = 1
    queueSongCover.layer?.masksToBounds = true
    queueSongIcon.wantsLayer = true
    setAppearance()
    
    if isPlaying {
      queueSongCover.layer?.filters = playingFilters
    } else {
      queueSongCover.layer?.filters = nil
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  
    queueSongCover.image = .defaultCoverArt
    queueSongCover.layer?.filters = nil
    queueSongIcon.image = nil
  }
  
  func setAppearance() {
    guard let viewLayer = queueSongCover.layer
      else { return }
    
    if #available(OSX 10.14, *) {
      let darkMode = NSApp.effectiveAppearance.bestMatch(from:
        [.darkAqua, .aqua]) == .darkAqua

      viewLayer.borderColor = darkMode ? .albumBorderColorDark : .albumBorderColorLight
    } else {
      viewLayer.borderColor = .albumBorderColorLight
     }
  }

  func setSong(_ queueItem: QueueItem, queueIcon: NSImage?) {
    let song = queueItem.song

    isPlaying = queueItem.isPlaying
    
    let provider = AlbumArtImageDataProvider(
      songUri: song.mpdSong.uriString,
      cacheKey: song.album.hash
    )

    queueSongCover.kf.setImage(
      with: .provider(provider),
      placeholder: NSImage.defaultCoverArt,
      options: [
        .processor(DownsamplingImageProcessor(size: .queueSongCoverSize)),
        .scaleFactor(2),
      ]
    )
    
    if isPlaying && queueIcon != nil {
      queueSongCover.layer?.filters = playingFilters
      queueSongIcon.image = queueIcon
    } else {
      queueSongCover.layer?.filters = nil
      queueSongIcon.image = nil
    }
  }
}
