//
//  QueueController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/01.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class QueueViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
  var queue: [MPDClient.Song] = []
  var queuePos: Int = -1

  var queueIcon: NSImage? = nil

  let systemFontRegular = NSFont.systemFont(ofSize: 13, weight: .regular)
  let systemFontBold = NSFont.systemFont(ofSize: 13, weight: .bold)

  let playIcon = NSImage(named: "playButton")
  let pauseIcon = NSImage(named: "pauseButton")

  struct SongItem {
    var song: MPDClient.Song
    var queuePos: Int
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    queueView.columnAutoresizingStyle = .sequentialColumnAutoresizingStyle

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(stateChanged(_:)),
      name: Notification.stateChanged,
      object: AppDelegate.mpdClient
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(queueChanged(_:)),
      name: Notification.queueChanged,
      object: AppDelegate.mpdClient
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(queuePosChanged(_:)),
      name: Notification.queuePosChanged,
      object: AppDelegate.mpdClient
    )
  }

  @IBAction func playTrack(_ sender: Any) {
    guard let view = sender as? NSOutlineView
      else { return }

    let queuePos = view.selectedRow - 1

    if queuePos >= 0 {
      AppDelegate.mpdClient.playTrack(queuePos: queuePos)
    }
  }

  @objc func stateChanged(_ notification: Notification) {
    guard let state = notification.userInfo?[Notification.stateKey] as? MPDClient.Status.State
      else { return }

    setQueueIcon(state)
  }

  @objc func queueChanged(_ notification: Notification) {
    guard let queue = notification.userInfo?[Notification.queueKey] as? [MPDClient.Song]
      else { return }

    self.queue = queue

    queueView.reloadData()
  }

  @objc func queuePosChanged(_ notification: Notification) {
    guard let queuePos = notification.userInfo?[Notification.queuePosKey] as? Int
      else { return }

    let oldSongRowPos = self.queuePos + 1
    let newSongRowPos = queuePos + 1
    self.queuePos = queuePos

    setQueuePos(oldSongRowPos: oldSongRowPos, newSongRowPos: newSongRowPos)

    queueView.reloadData(
      forRowIndexes: [oldSongRowPos, newSongRowPos],
      columnIndexes: [0, 1]
    )
  }

  func setQueueIcon(_ state: MPDClient.Status.State) {
    switch state {
    case .playing:
      self.queueIcon = playIcon
    case .paused:
      self.queueIcon = pauseIcon
    default:
      self.queueIcon = nil
    }
  }

  func setQueuePos(oldSongRowPos: Int, newSongRowPos: Int) {
    if oldSongRowPos > 0 {
      guard let oldSongRow = queueView.rowView(atRow: oldSongRowPos, makeIfNecessary: true),
        let oldSongTitleCell = oldSongRow.view(atColumn: 0) as? NSTableCellView
        else { return }

      setRowFont(rowView: oldSongRow, font: systemFontRegular)
      oldSongTitleCell.imageView?.image = nil
    }

    guard let songRow = queueView.rowView(atRow: newSongRowPos, makeIfNecessary: true),
      let newSongTitleCell = songRow.view(atColumn: 0) as? NSTableCellView
      else { return }

    setRowFont(rowView: songRow, font: systemFontBold)
    newSongTitleCell.imageView?.image = self.queueIcon
  }

  func setRowFont(rowView: NSTableRowView, font: NSFont) {
    guard let songTitleCell = rowView.view(atColumn: 0) as? NSTableCellView,
      let songArtistCell = rowView.view(atColumn: 1) as? NSTableCellView
      else { return }

    songTitleCell.textField?.font = font
    songArtistCell.textField?.font = font
  }

  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    return queue.count + 1
  }

  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return false
  }

  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if index > 0 {
      return SongItem(song: queue[index - 1], queuePos: index - 1)
    } else {
      return false
    }
  }

  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    if let songItem = item as? SongItem {
      switch tableColumn?.identifier.rawValue {
      case "songTitleColumn":
        let cellView = outlineView.makeView(
          withIdentifier: .queueSongTitle,
          owner: self
        ) as! NSTableCellView

        cellView.textField?.stringValue = songItem.song.getTag(.title)

        return cellView
      case "songArtistColumn":
        let cellView = outlineView.makeView(
          withIdentifier: .queueSongArtist,
          owner: self
        ) as! NSTableCellView

        cellView.textField?.stringValue = songItem.song.getTag(.artist)

        return cellView
      default:
        return nil
      }
    } else {
      if tableColumn?.identifier.rawValue == "songTitleColumn" {
        let cellView = outlineView.makeView(
          withIdentifier: .queueHeading,
          owner: self
        ) as! NSTableCellView

        cellView.textField?.stringValue = "QUEUE"

        return cellView
      } else {
        return nil
      }
    }
  }

  func outlineView(
    _ outlineView: NSOutlineView,
    selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet
  ) -> IndexSet {
    if proposedSelectionIndexes.contains(0) {
      return IndexSet()
    } else {
      return proposedSelectionIndexes
    }
  }

  @IBOutlet var queueView: NSOutlineView!
}
