//
//  AlbumViewItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class AlbumViewItem: NSCollectionViewItem {
  var observer: NSKeyValueObservation?
  var album: Album?

  override var isSelected: Bool {
    didSet {
      setAppearance(selected: isSelected)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    albumCoverView.wantsLayer = true
    albumCoverView.layer?.backgroundColor = NSColor.black.cgColor
    albumCoverView.layer?.cornerRadius = 4
    albumCoverView.layer?.borderWidth = 1
    albumCoverView.layer?.masksToBounds = true

    albumCoverBox.wantsLayer = true
    albumCoverBox.layer?.cornerRadius = 7
    albumCoverBox.layer?.borderWidth = 5

    setAppearance(selected: false)

    if #available(OSX 10.14, *) {
      observer = NSApp.observe(\.effectiveAppearance) { (app, _) in
        self.setAppearance(selected: false)
      }
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    AlbumDetailView.popover.close()
  }

  func setAlbum(_ album: Album) {
    self.album = album
    albumTitle.stringValue = album.title
    albumArtist.stringValue = album.artist

    switch album.coverArt {
    case .loaded(let coverArt):
      albumCoverView.image = coverArt ?? .defaultCoverArt
    default:
      albumCoverView.image = .defaultCoverArt
    }
  }

  func setAppearance(selected isSelected: Bool) {
    if #available(OSX 10.14, *) {
      let darkMode = NSApp.effectiveAppearance.bestMatch(from:
        [.darkAqua, .aqua]) == .darkAqua

      albumCoverView.layer?.borderColor = darkMode ? .albumBorderColorDark : .albumBorderColorLight
      albumCoverBox.layer?.borderColor = isSelected ? NSColor.controlAccentColor.cgColor : CGColor.clear
      albumCoverBox.layer?.backgroundColor = isSelected ? NSColor.controlAccentColor.cgColor : CGColor.clear
    } else {
      albumCoverView.layer?.borderColor = .albumBorderColorLight
      albumCoverBox.layer?.borderColor = isSelected ? NSColor.selectedControlColor.cgColor : CGColor.clear
      albumCoverBox.layer?.backgroundColor = isSelected ? NSColor.selectedControlColor.cgColor : CGColor.clear
    }
  }

  @IBAction func showAlbumDetail(_ sender: NSButton) {
    guard let album = album else { return }

    AlbumDetailView.shared.setAlbum(album)

    AlbumDetailView.popover.contentViewController = AlbumDetailView.shared
    AlbumDetailView.popover.behavior = .transient
    AlbumDetailView.popover.show(
      relativeTo: albumCoverView.bounds,
      of: albumCoverView,
      preferredEdge: .maxY
    )
  }

  @IBOutlet var albumCoverBox: NSBox!
  @IBOutlet var albumCoverView: NSButton!
  @IBOutlet var albumTitle: NSTextField!
  @IBOutlet var albumArtist: NSTextField!
}
