//
//  AlbumViewItem.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import Kingfisher

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

    albumCoverView.image = .defaultCoverArt
    AlbumDetailView.popover.close()
  }

  func setAlbum(_ album: Album) {
    self.album = album
    albumTitle.stringValue = album.title
    albumArtist.stringValue = album.artist
    setAlbumCover(album)
  }

  func setAlbumCover(_ album: Album) {
    guard let song = album.mpdAlbum.firstSong
      else { return }

    let provider = MPDAlbumArtImageDataProvider(
      songUri: song.uriString,
      cacheKey: album.hash
    )

    albumCoverView.kf.setImage(
      with: .provider(provider),
      placeholder: NSImage.defaultCoverArt,
      options: [
        .processor(DownsamplingImageProcessor(size: .albumListCoverSize)),
        .scaleFactor(2),
      ]
    ) { result in
      switch result {
      case .success(let imageResult):
        guard let imageData = imageResult.image.tiffRepresentation
          else { return }
        
        let rawProvider = RawImageDataProvider(
          data: imageData,
          cacheKey: album.hash
        )
        
        self.cacheSmallCover(provider: rawProvider)

      case .failure(_):
        break
      }
    }
  }
  
  func cacheSmallCover(provider: ImageDataProvider) {
    _ = KingfisherManager.shared.retrieveImage(
      with: .provider(provider),
      options: [
        .memoryCacheExpiration(.never),
        .processor(DownsamplingImageProcessor(size: .queueSongCoverSize)),
        .scaleFactor(2),
      ]
    ) { result in }
  }

  func setAppearance(selected isSelected: Bool) {
    guard let viewLayer = albumCoverView.layer,
      let boxLayer = albumCoverBox.layer
      else { return }

    if #available(OSX 10.14, *) {
      let darkMode = NSApp.effectiveAppearance.bestMatch(from:
        [.darkAqua, .aqua]) == .darkAqua

      viewLayer.borderColor = darkMode ? .albumBorderColorDark : .albumBorderColorLight
      boxLayer.borderColor = isSelected ? NSColor.controlAccentColor.cgColor : CGColor.clear
      boxLayer.backgroundColor = albumCoverBox.layer?.borderColor
    } else {
      viewLayer.borderColor = .albumBorderColorLight
      boxLayer.borderColor = isSelected ? NSColor.selectedControlColor.cgColor : CGColor.clear
      boxLayer.backgroundColor = albumCoverBox.layer?.borderColor
    }
  }
  
  func refreshAlbumArt() {
    guard let album = album,
      let mpdSong = album.mpdAlbum.firstSong
      else { return }
      
    let song = Song(mpdSong: mpdSong)
    
    CoverArtService(song: song).refresh {
      self.setAlbumCover(album)
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
  
  @IBAction func playAlbumMenuAction(_ sender: NSMenuItem) {
    guard let album = album else { return }
    
    App.mpdClient.playAlbum(album.mpdAlbum)
  }

  @IBAction func addAlbumToQueueMenuAction(_ sender: NSMenuItem) {
    guard let album = album else { return }
    
    let queueLength = App.store.state.queueState.queue.count

    App.mpdClient.addAlbumToQueue(album: album.mpdAlbum, at: queueLength)
  }

  @IBAction func refreshAlbumArtMenuAction(_ sender: NSMenuItem) {
    refreshAlbumArt()
  }
}
