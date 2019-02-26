//
//  AlbumItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumItem: NSCollectionViewItem {
  var observer: NSKeyValueObservation?
  var album: MPDClient.Album?

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

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(fetchAlbumArt(_:)),
      name: Notification.Name("fetchAlbumArt"),
      object: nil
    )
  }

  @objc func fetchAlbumArt(_ notification: Notification) {
    guard let album = album else { return }

    AlbumArtService.shared.fetchAlbumArt(for: album) { image in
      DispatchQueue.main.async { [unowned self] in
        self.albumCoverView.image = image
      }
    }
  }

  func setAlbum(_ album: MPDClient.Album) {
    self.album = album
    albumTitle.stringValue = album.title
    albumArtist.stringValue = album.artist
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
    
    AppDelegate.mpdClient.playAlbum(album)
  }

  @IBOutlet var albumCoverView: NSImageView!
  @IBOutlet var albumTitle: NSTextField!
  @IBOutlet var albumArtist: NSTextField!
}
