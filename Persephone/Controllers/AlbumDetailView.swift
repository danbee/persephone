//
//  AlbumDetailView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/18.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

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

  func getAlbumSongs(for album: Album) {
    App.mpdClient.getAlbumSongs(for: album.mpdAlbum) { [weak self] (mpdSongs: [MPDClient.MPDSong]) in
      self?.dataSource.setAlbumSongs(
        mpdSongs.map { Song(mpdSong: $0) }
      )

      self?.getBigCoverArt(song: self?.dataSource.albumSongs.first!.song ?? (self?.dataSource.albumSongs[1].song!)!)

      DispatchQueue.main.async {
        self?.albumTracksView.reloadData()
      }
    }
  }

  func getBigCoverArt(song: Song) {
    let coverArtService = CoverArtService(song: song)

    coverArtService.fetchBigCoverArt()
      .done() { [weak self] image in
        DispatchQueue.main.async {
          if let image = image {
            self?.albumCoverView.image = image
          }
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

extension AlbumDetailView: NSTableViewDelegate {
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    if let song = dataSource.albumSongs[row].song {
      switch tableColumn?.identifier.rawValue {
      case "trackNumberColumn":
        return cellForTrackNumber(tableView, with: song)
      case "trackTitleColumn":
        return cellForSongTitle(tableView, with: song)
      case "trackDurationColumn":
        return cellForSongDuration(tableView, with: song)
      default:
        return nil
      }
    } else if let disc = dataSource.albumSongs[row].disc {
      return cellForDiscNumber(tableView, with: disc)
    }

    return nil
  }

  func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
    return dataSource.albumSongs[row].disc != nil
  }

  func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
    let view = AlbumDetailSongRowView()

    return view
  }

  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
    return dataSource.albumSongs[row].disc == nil
  }

  func cellForDiscNumber(_ tableView: NSTableView, with disc: String) -> NSView {
    let cellView = tableView.makeView(
      withIdentifier: .discNumber,
      owner: self
      ) as! NSTableCellView

    cellView.textField?.stringValue = "Disc \(disc)"

    return cellView
  }

  func cellForTrackNumber(_ tableView: NSTableView, with song: Song) -> NSView {
    let cellView = tableView.makeView(
      withIdentifier: .trackNumber,
      owner: self
      ) as! NSTableCellView

    cellView.textField?.stringValue = "\(song.trackNumber)."

    return cellView
  }

  func cellForSongTitle(_ tableView: NSTableView, with song: Song) -> NSView {
    let cellView = tableView.makeView(
      withIdentifier: .songTitle,
      owner: self
    ) as! NSTableCellView

    cellView.textField?.stringValue = song.title

    return cellView
  }

  func cellForSongDuration(_ tableView: NSTableView, with song: Song) -> NSView {
    let cellView = tableView.makeView(
      withIdentifier: .songDuration,
      owner: self
      ) as! NSTableCellView

    cellView.textField?.font = .timerFont
    cellView.textField?.stringValue = song.duration.formattedTime

    return cellView
  }
}
