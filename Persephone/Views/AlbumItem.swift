//
//  AlbumItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumItem: NSCollectionViewItem {
  let borderColorLight = NSColor.black.withAlphaComponent(0.1).cgColor
  let borderColorDark = NSColor.white.withAlphaComponent(0.1).cgColor
  var observer: NSKeyValueObservation?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.

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

  func setAlbum(_ album: MPDClient.Album) {
    albumTitle.stringValue = album.title
    albumArtist.stringValue = album.artist
  }

  func setAppearance() {
    if #available(OSX 10.14, *) {
      let darkMode = NSApp.effectiveAppearance.bestMatch(from:
        [.darkAqua, .aqua]) == .darkAqua

      albumCoverView.layer?.borderColor = darkMode ? borderColorDark : borderColorLight
    } else {
      albumCoverView.layer?.borderColor = borderColorLight
    }
  }

  @IBOutlet var albumCoverView: NSImageView!
  @IBOutlet var albumTitle: NSTextField!
  @IBOutlet var albumArtist: NSTextField!
}
