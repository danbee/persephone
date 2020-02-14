//
//  AlbumDetailView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/18.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import Kingfisher

class AlbumDetailView: NSViewController {
  var observer: NSKeyValueObservation?
  var album: Album?
  var dataSource = AlbumTracksDataSource()

  static let shared = AlbumDetailView()
  static let popover = NSPopover()

  @IBOutlet var albumTracksView: NSTableView!
  @IBOutlet var albumTitle: NSTextField!
  @IBOutlet var albumMetadata: NSTextFieldCell!
  @IBOutlet var albumCoverView: NSImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    albumTracksView.dataSource = dataSource
    albumTracksView.delegate = self
    albumTracksView.intercellSpacing = CGSize(width: 0, height: 18)
    albumTracksView.floatsGroupRows = false
    albumTracksView.columnAutoresizingStyle = .sequentialColumnAutoresizingStyle

    albumCoverView.wantsLayer = true
    albumCoverView.layer?.backgroundColor = NSColor.black.cgColor
    albumCoverView.layer?.cornerRadius = 6
    albumCoverView.layer?.borderWidth = 1
    albumCoverView.layer?.masksToBounds = true
    setAppearance()

    if #available(OSX 10.14, *) {
      observer = NSApp.observe(\.effectiveAppearance) { (app, _) in
        self.setAppearance()
      }
    }
  }

  override func viewWillAppear() {
    guard let album = album else { return }

    getAlbumSongs(for: album)

    let date = album.mpdAlbum.date ?? ""

    albumTitle.stringValue = album.title
    albumMetadata.stringValue = "\(album.artist) · \(date)"

    super.viewWillAppear()
  }

  override func viewWillDisappear() {
    dataSource.albumSongs = []
    albumTracksView.reloadData()
    albumTitle.stringValue = ""
    albumMetadata.stringValue = ""
    albumCoverView.image = .defaultCoverArt

    App.store.dispatch(SetSelectedSong(selectedSong: nil))
  }

  @IBAction func playAlbum(_ sender: NSButton) {
    guard let album = album else { return }

    App.mpdClient.playAlbum(album.mpdAlbum)
  }

  @IBAction func playSong(_ sender: AlbumDetailSongListView) {
    guard let song = dataSource.albumSongs[sender.selectedRow].song
      else { return }

    let queueLength = App.store.state.queueState.queue.count
    App.mpdClient.appendSong(song.mpdSong)
    App.mpdClient.fetchQueue()
    App.mpdClient.playTrack(at: queueLength)
  }

  @IBAction func menuActionPlaySong(_ sender: NSMenuItem) {
    guard let song = dataSource.albumSongs[albumTracksView.clickedRow].song
      else { return }

    let queueLength = App.store.state.queueState.queue.count
    App.mpdClient.appendSong(song.mpdSong)
    App.mpdClient.fetchQueue()
    App.mpdClient.playTrack(at: queueLength)
  }

  @IBAction func menuActionPlayNext(_ sender: Any) {
    guard let song = dataSource.albumSongs[albumTracksView.clickedRow].song
      else { return }

    let queuePos = App.store.state.queueState.queuePos

    if queuePos > -1 {
      App.mpdClient.addSongToQueue(songUri: song.mpdSong.uriString, at: queuePos + 1)
    }
  }

  @IBAction func menuActionAppendSong(_ sender: NSMenuItem) {
    guard let song = dataSource.albumSongs[albumTracksView.clickedRow].song
      else { return }

    App.mpdClient.appendSong(song.mpdSong)
  }

  func getAlbumSongs(for album: Album) {
    App.mpdClient.getAlbumSongs(for: album.mpdAlbum) { [weak self] (mpdSongs: [MPDClient.MPDSong]) in
      guard let self = self else { return }

      DispatchQueue.main.async {
        self.dataSource.setAlbumSongs(
          mpdSongs.map { Song(mpdSong: $0) }
        )

        self.albumTracksView.reloadData()

        guard !self.dataSource.albumSongs.isEmpty,
          let song = self.dataSource.albumSongs.first?.song ??
          self.dataSource.albumSongs[1].song
          else { return }

        self.getBigCoverArt(song: song, album: album)
      }
    }
  }

  func getBigCoverArt(song: Song, album: Album) {
    let provider = MPDAlbumArtImageDataProvider(
      songUri: song.mpdSong.uriString,
      cacheKey: album.hash
    )

    albumCoverView.kf.setImage(
      with: .provider(provider),
      placeholder: NSImage.defaultCoverArt,
      options: [
        .processor(DownsamplingImageProcessor(size: .albumDetailCoverSize)),
        .scaleFactor(2),
      ]
    )

    cacheSmallCover(provider: provider)
  }
  
  func cacheSmallCover(provider: MPDAlbumArtImageDataProvider) {
    _ = KingfisherManager.shared.retrieveImage(
      with: .provider(provider),
      options: [
        .memoryCacheExpiration(.never),
        .processor(DownsamplingImageProcessor(size: .queueSongCoverSize)),
        .scaleFactor(2),
      ]
    ) { result in }
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

  func setAlbum(_ album: Album) {
    self.album = album
  }
}
