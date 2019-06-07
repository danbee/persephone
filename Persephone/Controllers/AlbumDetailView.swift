//
//  AlbumDetailView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/18.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class AlbumDetailView: NSViewController {
  var album: Album?
  var dataSource = AlbumTracksDataSource()

  static let shared = AlbumDetailView()
  static let popover = NSPopover()

  @IBOutlet var albumTracksView: NSTableView!
  @IBOutlet var albumTitle: NSTextField!
  @IBOutlet var albumArtist: NSTextField!
  @IBOutlet var albumCoverView: NSImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    albumTracksView.dataSource = dataSource
    albumTracksView.delegate = self
    albumTracksView.intercellSpacing = CGSize(width: 0, height: 18)
    albumTracksView.floatsGroupRows = false
    albumTracksView.columnAutoresizingStyle = .sequentialColumnAutoresizingStyle

    albumCoverView.wantsLayer = true
    albumCoverView.layer?.cornerRadius = 5
    albumCoverView.layer?.borderWidth = 1
    setAppearance()

  }

  override func viewWillAppear() {
    guard let album = album else { return }

    getAlbumSongs(for: album)

    albumTitle.stringValue = album.title
    albumArtist.stringValue = album.artist

    switch album.coverArt {
    case .loaded(let coverArt):
      albumCoverView.image = coverArt ?? .defaultCoverArt
    default:
      albumCoverView.image = .defaultCoverArt
    }

    super.viewWillAppear()
  }

  override func viewWillDisappear() {
    dataSource.albumSongs = []
    albumTracksView.reloadData()
    albumTitle.stringValue = ""
    albumArtist.stringValue = ""
    albumCoverView.image = .defaultCoverArt

    App.store.dispatch(SetSelectedSong(selectedSong: nil))
  }

  @IBAction func playAlbum(_ sender: NSButton) {
    guard let album = album else { return }

    App.store.dispatch(MPDPlayAlbum(album: album.mpdAlbum))
  }

  @IBAction func playSong(_ sender: AlbumDetailSongListView) {
    guard let song = dataSource.albumSongs[sender.selectedRow].song
      else { return }

    let queueLength = App.store.state.queueState.queue.count
    App.store.dispatch(MPDAppendTrack(song: song.mpdSong))
    App.store.dispatch(MPDPlayTrack(queuePos: queueLength))
  }

  @IBAction func menuActionPlaySong(_ sender: NSMenuItem) {
    guard let song = dataSource.albumSongs[albumTracksView.clickedRow].song
      else { return }

    let queueLength = App.store.state.queueState.queue.count
    App.store.dispatch(MPDAppendTrack(song: song.mpdSong))
    App.store.dispatch(MPDPlayTrack(queuePos: queueLength))
  }

  @IBAction func menuActionAppendSong(_ sender: NSMenuItem) {
    guard let song = dataSource.albumSongs[albumTracksView.clickedRow].song
      else { return }

    App.store.dispatch(MPDAppendTrack(song: song.mpdSong))
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

      self.getBigCoverArt(song: song)
    }
  }

  func getBigCoverArt(song: Song) {
    let coverArtService = CoverArtService(song: song)

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
