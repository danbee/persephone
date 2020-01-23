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
  @IBOutlet var queueSongButton: NSButton!
  
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
    queueSongButton.wantsLayer = true
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
    guard let imagePath = queueItem.song.album.coverArtFilePath
      else { return }

    isPlaying = queueItem.isPlaying

    let imageURL = URL(fileURLWithPath: imagePath)
    let provider = LocalFileImageDataProvider(fileURL: imageURL)
    
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
      queueSongButton.image = queueIcon
    } else {
      queueSongCover.layer?.filters = nil
      queueSongButton.image = nil
    }
  }
}
