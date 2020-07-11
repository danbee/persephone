//
//  AlbumDetailView+NSTableViewDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/07.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

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

  func tableViewSelectionDidChange(_ notification: Notification) {
    guard let tableView = notification.object as? NSTableView
      else { return }

    if tableView.selectedRow >= 0 {
      let song = dataSource.albumSongs[tableView.selectedRow].song

      App.store.dispatch(SetSelectedSong(selectedSong: song))
    } else {
      App.store.dispatch(SetSelectedSong(selectedSong: nil))
    }
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
      ) as! AlbumDetailSongTitleView

    cellView.setShowArtist(dataSource.showSongArtist)
    cellView.setSong(song)

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
