//
//  artistViewItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class ArtistViewItem: NSCollectionViewItem {
  var observer: NSKeyValueObservation?
  var artist: Artist?

//  override var isSelected: Bool {
//    didSet {
//      artistCoverBox.layer?.borderWidth = isSelected ? 5 : 0
//    }
//  }

  override func viewDidLoad() {
    super.viewDidLoad()
//
//    artistCoverView.wantsLayer = true
//    artistCoverView.layer?.cornerRadius = 3
//    artistCoverView.layer?.borderWidth = 1
//
//    artistCoverBox.wantsLayer = true
//    artistCoverBox.layer?.cornerRadius = 5
//    artistCoverBox.layer?.borderWidth = 0
//
//    setAppearance()
//
//    if #available(OSX 10.14, *) {
//      observer = NSApp.observe(\.effectiveAppearance) { (app, _) in
//        self.setAppearance()
//      }
//    }
  }

//  override func prepareForReuse() {
//    super.prepareForReuse()
//
//    artistDetailView.popover.close()
//  }

  func setArtist(_ artist: Artist) {
    self.artist = artist
    artistName.stringValue = artist.name
  }

//  func setAppearance() {
//    if #available(OSX 10.14, *) {
//      let darkMode = NSApp.effectiveAppearance.bestMatch(from:
//        [.darkAqua, .aqua]) == .darkAqua
//
//      artistCoverView.layer?.borderColor = darkMode ? .albumBorderColorDark : .albumBorderColorLight
//      artistCoverBox.layer?.borderColor = NSColor.controlAccentColor.cgColor
//    } else {
//      artistCoverView.layer?.borderColor = .albumBorderColorLight
//      artistImageBox.layer?.borderColor = NSColor.selectedControlColor.cgColor
//    }
//  }

  @IBOutlet var artistName: NSTextField!
}
