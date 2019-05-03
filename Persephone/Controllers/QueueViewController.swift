//
//  QueueController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/01.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import ReSwift

class QueueViewController: NSViewController,
                           NSOutlineViewDelegate {
  var dataSource = QueueDataSource()

  @IBOutlet var queueView: NSOutlineView!
  @IBOutlet var queueCoverArtImage: NSImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    App.store.subscribe(self) {
      $0.select { $0.queueState }
    }

    queueView.dataSource = dataSource
    queueView.columnAutoresizingStyle = .sequentialColumnAutoresizingStyle
  }

  override func keyDown(with event: NSEvent) {
    switch event.keyCode {
    case NSEvent.keyCodeSpace:
      nextResponder?.keyDown(with: event)
    default:
      super.keyDown(with: event)
    }
  }

  @IBAction func playTrack(_ sender: Any) {
    let newQueuePos = queueView.selectedRow - 1

    if newQueuePos >= 0 {
      App.store.dispatch(MPDPlayTrack(queuePos: newQueuePos))
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

  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    if let queueItem = item as? QueueItem {
      switch tableColumn?.identifier.rawValue {
      case "songTitleColumn":
        return cellForSongTitle(outlineView, with: queueItem)
      case "songArtistColumn":
        return cellForSongArtist(outlineView, with: queueItem)
      default:
        return nil
      }
    } else if tableColumn?.identifier.rawValue == "songTitleColumn" {
      return cellForQueueHeading(outlineView)
    } else {
      return nil
    }
  }

func cellForSongTitle(_ outlineView: NSOutlineView, with queueItem: QueueItem) -> NSView {
    let cellView = outlineView.makeView(
      withIdentifier: .queueSongTitle,
      owner: self
    ) as! NSTableCellView

    cellView.textField?.stringValue = queueItem.song.title
    if queueItem.isPlaying {
      cellView.textField?.font = .systemFontBold
      cellView.imageView?.image = dataSource.queueIcon
    } else {
      cellView.textField?.font = .systemFontRegular
      cellView.imageView?.image = nil
    }

    return cellView
  }

  func cellForSongArtist(_ outlineView: NSOutlineView, with queueItem: QueueItem) -> NSView {
    let cellView = outlineView.makeView(
      withIdentifier: .queueSongArtist,
      owner: self
    ) as! NSTableCellView

    cellView.textField?.stringValue = queueItem.song.artist
    if queueItem.isPlaying {
      cellView.textField?.font = .systemFontBold
    } else {
      cellView.textField?.font = .systemFontRegular
    }

    return cellView
  }

  func cellForQueueHeading(_ outlineView: NSOutlineView) -> NSView {
    let cellView = outlineView.makeView(
      withIdentifier: .queueHeading,
      owner: self
    ) as! NSTableCellView

    cellView.textField?.stringValue = "QUEUE"

    return cellView
  }
}

extension QueueViewController: StoreSubscriber {
  typealias StoreSubscriberStateType = QueueState

  func newState(state: StoreSubscriberStateType) {
    dataSource.queue = state.queue
    dataSource.setQueueIcon(state)
    queueView.reloadData()
  }
}
