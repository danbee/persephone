//
//  QueueController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/01.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import mpdclient

class QueueController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {
  var queue: [MPDClient.Song] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    queueView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(queueChanged(_:)),
      name: MPDClient.queueChanged,
      object: AppDelegate.mpdClient
    )
  }

  @objc func queueChanged(_ notification: Notification) {
    guard let queue = notification.userInfo?[MPDClient.queueKey] as? [MPDClient.Song]
      else { return }

    self.queue = queue

    queueView.reloadData()
  }

  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    return queue.count + 1
  }

  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return false
  }

  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    if index > 0 {
      return queue[index - 1]
    } else {
      return ""
    }
  }

  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    if let song = item as? MPDClient.Song {
      switch tableColumn?.identifier.rawValue {
      case "songTitleColumn":
        let cellView = outlineView.makeView(
          withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "songTitleCell"),
          owner: self
        ) as! NSTableCellView

        cellView.textField?.stringValue = song.getTag(MPD_TAG_TITLE)

        return cellView
      case "songArtistColumn":
        let cellView = outlineView.makeView(
          withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "songArtistCell"),
          owner: self
        ) as! NSTableCellView

        cellView.textField?.stringValue = song.getTag(MPD_TAG_ARTIST)

        return cellView
      default:
        return nil
      }
    } else {
      if tableColumn?.identifier.rawValue == "songTitleColumn" {
        let cellView = outlineView.makeView(
          withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "queueHeadingCell"),
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
