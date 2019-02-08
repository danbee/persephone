//
//  QueueController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/01.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import mpdclient

class QueueViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
  var queue: [MPDClient.Song] = []
  var queuePos: Int32 = -1

  let systemFontRegular = NSFont.systemFont(ofSize: 13, weight: .regular)
  let systemFontBold = NSFont.systemFont(ofSize: 13, weight: .bold)

  struct SongItem {
    var song: MPDClient.Song
    var queuePos: Int
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    queueView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(queueChanged(_:)),
      name: MPDClient.queueChanged,
      object: AppDelegate.mpdClient
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(queuePosChanged(_:)),
      name: MPDClient.queuePosChanged,
      object: AppDelegate.mpdClient
    )
  }

  @objc func queueChanged(_ notification: Notification) {
    guard let queue = notification.userInfo?[MPDClient.queueKey] as? [MPDClient.Song]
      else { return }

    self.queue = queue

    queueView.reloadData()
  }

  @objc func queuePosChanged(_ notification: Notification) {
    guard let queuePos = notification.userInfo?[MPDClient.queuePosKey] as? Int32
      else { return }

    let oldSongRowPos = Int(self.queuePos + 1)
    let newSongRowPos = Int(queuePos + 1)
    self.queuePos = queuePos

    setQueuePos(oldSongRowPos: oldSongRowPos, newSongRowPos: newSongRowPos)

    queueView.reloadData(
      forRowIndexes: [oldSongRowPos, newSongRowPos],
      columnIndexes: [0, 1]
    )
  }

  func setQueuePos(oldSongRowPos: Int, newSongRowPos: Int) {
    if oldSongRowPos > 0 {
      guard let oldSongRow = queueView.rowView(atRow: oldSongRowPos, makeIfNecessary: true)
        else { return }
      guard let oldSongTitleCell = oldSongRow.view(atColumn: 0) as? NSTableCellView
        else { return }

      setRowFont(rowView: oldSongRow, font: systemFontRegular)
      oldSongTitleCell.imageView?.image = nil
    }

    guard let songRow = queueView.rowView(atRow: newSongRowPos, makeIfNecessary: true)
      else { return }
    guard let newSongTitleCell = songRow.view(atColumn: 0) as? NSTableCellView
      else { return }

    setRowFont(rowView: songRow, font: systemFontBold)
    newSongTitleCell.imageView?.image = NSImage(named: NSImage.Name("playButton"))
  }

  func setRowFont(rowView: NSTableRowView, font: NSFont) {
    guard let songTitleCell = rowView.view(atColumn: 0) as? NSTableCellView
      else { return }
    guard let songArtistCell = rowView.view(atColumn: 1) as? NSTableCellView
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
      return ""
    }
  }

  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    if let songItem = item as? SongItem {
      switch tableColumn?.identifier.rawValue {
      case "songTitleColumn":
        let cellView = outlineView.makeView(
          withIdentifier: NSUserInterfaceItemIdentifier("songTitleCell"),
          owner: self
        ) as! NSTableCellView

        cellView.textField?.stringValue = songItem.song.getTag(MPD_TAG_TITLE)

        return cellView
      case "songArtistColumn":
        let cellView = outlineView.makeView(
          withIdentifier: NSUserInterfaceItemIdentifier("songArtistCell"),
          owner: self
        ) as! NSTableCellView

        cellView.textField?.stringValue = songItem.song.getTag(MPD_TAG_ARTIST)

        return cellView
      default:
        return nil
      }
    } else {
      if tableColumn?.identifier.rawValue == "songTitleColumn" {
        let cellView = outlineView.makeView(
          withIdentifier: NSUserInterfaceItemIdentifier("queueHeadingCell"),
          owner: self
        ) as! NSTableCellView

        cellView.textField?.stringValue = "QUEUE"

        return cellView
      } else {
        return nil
      }
    }
  }

  @IBOutlet var queueView: NSOutlineView!
}
