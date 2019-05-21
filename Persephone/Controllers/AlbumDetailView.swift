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

  @IBOutlet var albumTracksView: NSTableView!
  @IBOutlet var albumTitle: NSTextField!
  @IBOutlet var albumArtist: NSTextField!
  @IBOutlet var albumCoverView: NSImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    albumTracksView.dataSource = dataSource
    albumTracksView.delegate = self
    albumTracksView.intercellSpacing = CGSize(width: 0, height: 13)
    albumTracksView.gridStyleMask = .solidHorizontalGridLineMask

    albumCoverView.wantsLayer = true
    albumCoverView.layer?.cornerRadius = 5
    albumCoverView.layer?.borderWidth = 1
    setAppearance()

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
  }

  func getAlbumSongs(for album: Album) {
    App.mpdClient.getAlbumSongs(for: album.mpdAlbum) { (mpdSongs: [MPDClient.MPDSong]) in
      self.dataSource.albumTracks = mpdSongs.map {
        return Song(mpdSong: $0)
      }

      DispatchQueue.main.async {
        self.albumTracksView.reloadData()
      }
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

  func setAlbum(_ album: Album) {
    self.album = album
  }
}

extension AlbumDetailView: NSTableViewDelegate {
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let song = dataSource.albumTracks[row]

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
  }

  func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
    let view = NSTableRowView()

    return view
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
