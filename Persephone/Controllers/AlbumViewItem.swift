//
//  AlbumViewItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumViewItem: NSCollectionViewItem {
  var observer: NSKeyValueObservation?
  var album: AlbumItem?

  override func viewDidLoad() {
    super.viewDidLoad()

    albumCoverView.wantsLayer = true
    albumCoverView.layer?.cornerRadius = 3
    albumCoverView.layer?.borderWidth = 1
    setAppearance()

    if #available(OSX 10.14, *) {
      observer = NSApp.observe(\.effectiveAppearance) { (app, _) in
        self.setAppearance()
      }
    }
  }

  func setAlbum(_ album: AlbumItem) {
    self.album = album
    albumTitle.stringValue = album.title
    albumArtist.stringValue = album.artist
    
    if let coverArt = album.coverArt {
      albumCoverView.image = coverArt
    } else {
      albumCoverView.image = .defaultCoverArt
    }
  }

  func setAppearance() {
    if #available(OSX 10.14, *) {
      let darkMode = NSApp.effectiveAppearance.bestMatch(from:
        [.darkAqua, .aqua]) == .darkAqua

      albumCoverView.layer?.borderColor = darkMode ? .albumBorderColorDark : .albumBorderColorLight
    } else {
      albumCoverView.layer?.borderColor = .albumBorderColorLight
    }
  }

  @IBAction func playAlbum(_ sender: Any) {
    guard let album = album else { return }
    
    AppDelegate.mpdClient.playAlbum(album.album)
  }

  @IBOutlet var albumCoverView: NSImageView!
  @IBOutlet var albumTitle: NSTextField!
  @IBOutlet var albumArtist: NSTextField!
}
