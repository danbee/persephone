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
    return queue.count
  }

  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return false
  }

  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    return queue[index]
  }

  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    guard let song = item as? MPDClient.Song else { return nil }

    let tableView = outlineView.makeView(
      withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "songItemCell"),
      owner: self
    ) as! NSTableCellView

    tableView.textField?.stringValue = "\(song.getTag(MPD_TAG_TITLE)) - \(song.getTag(MPD_TAG_ARTIST))"

    return tableView
  }

  @IBOutlet var queueView: NSOutlineView!
}
