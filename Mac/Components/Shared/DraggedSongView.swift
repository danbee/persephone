//
//  DraggedSong.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/18.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import Kingfisher

class DraggedSongView: NSViewController {
  @IBOutlet var titleLabel: NSTextField!
  @IBOutlet var artistLabel: NSTextField!
  @IBOutlet var coverImage: NSImageView!
  
  private let songTitle: String
  private let songArtist: String
  private let songAlbumArtist: String
  private let songAlbum: String
  private let songUri: String

  init(title: String, artist: String, albumArtist: String, album: String, uri: String) {
    songTitle = title
    songArtist = artist
    songAlbumArtist = albumArtist
    songAlbum = album
    songUri = uri

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    coverImage.wantsLayer = true
    coverImage.layer?.backgroundColor = CGColor.black
    coverImage.layer?.cornerRadius = 2
    coverImage.layer?.borderWidth = 1
    coverImage.layer?.masksToBounds = true

    setAppearance()
    
    titleLabel.stringValue = songTitle
    artistLabel.stringValue = songArtist
    setCoverArt()
  }
  
  func setAppearance() {
    if #available(OSX 10.14, *) {
      let darkMode = NSApp.effectiveAppearance.bestMatch(from:
        [.darkAqua, .aqua]) == .darkAqua

      coverImage.layer?.borderColor = darkMode ? .albumBorderColorDark : .albumBorderColorLight
    } else {
      coverImage.layer?.borderColor = .albumBorderColorLight
    }
  }
  
  func setCoverArt() {
    let mpdAlbum = MPDClient.MPDAlbum(title: songAlbum, artist: songAlbumArtist)

    let provider = AlbumArtImageDataProvider(
      songUri: songUri,
      cacheKey: Album(mpdAlbum: mpdAlbum).hash
    )

    coverImage.kf.setImage(
      with: .provider(provider),
      placeholder: NSImage.defaultCoverArt,
      options: [
        .processor(DownsamplingImageProcessor(size: .queueSongCoverSize)),
        .scaleFactor(2),
      ]
    )
  }
}
