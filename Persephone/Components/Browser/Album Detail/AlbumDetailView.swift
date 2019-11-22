//
//  AlbumDetailView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/18.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

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
    App.mpdClient.playTrack(at: queueLength)
  }

  @IBAction func menuActionPlaySong(_ sender: NSMenuItem) {
    guard let song = dataSource.albumSongs[albumTracksView.clickedRow].song
      else { return }

    let queueLength = App.store.state.queueState.queue.count
    App.mpdClient.appendSong(song.mpdSong)
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

      self.dataSource.setAlbumSongs(
        mpdSongs.map { Song(mpdSong: $0) }
      )

      DispatchQueue.main.async {
        self.albumTracksView.reloadData()
      }

      guard let song = self.dataSource.albumSongs.first?.song ??
        self.dataSource.albumSongs[1].song
        else { return }

      self.getBigCoverArt(song: song, album: album)
    }
  }

  func getBigCoverArt(song: Song, album: Album) {
    let coverArtService = CoverArtService(path: song.mpdSong.path, album: album)

    coverArtService.fetchBigCoverArt()
      .done(on: DispatchQueue.main) { [weak self] image in
        if let image = image {
          self?.albumCoverView.image = image
        }
      }
      .cauterize()
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
