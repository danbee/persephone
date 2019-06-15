//
//  QueueController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/01.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import ReSwift

class QueueViewController: NSViewController {
  var dataSource = QueueDataSource()

  @IBOutlet var queueView: NSOutlineView!
  @IBOutlet var queueCoverArtImage: NSImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    App.store.subscribe(self) {
      $0.select { $0.queueState }
    }

//    queueView.dataSource = dataSource
    queueView.columnAutoresizingStyle = .sequentialColumnAutoresizingStyle
    queueView.registerForDraggedTypes([REORDER_PASTEBOARD_TYPE])
    queueView.draggingDestinationFeedbackStyle = .regular
  }

  override func keyDown(with event: NSEvent) {
    switch event.keyCode {
    case NSEvent.keyCodeSpace:
      nextResponder?.keyDown(with: event)
    case NSEvent.keyCodeBS:
      let queuePos = queueView.selectedRow - 1

      if queuePos >= 0 {
        App.store.dispatch(MPDRemoveTrack(queuePos: queuePos))
      }
    default:
      super.keyDown(with: event)
    }
  }

  @IBAction func playTrack(_ sender: Any) {
    let queuePos = queueView.selectedRow - 1

    if queuePos >= 0 {
      App.store.dispatch(MPDPlayTrack(queuePos: queuePos))
    }
  }
  
  @IBAction func playSongMenuAction(_ sender: NSMenuItem) {
    let queuePos = queueView.clickedRow - 1

    if queuePos >= 0 {
      App.store.dispatch(MPDPlayTrack(queuePos: queuePos))
    }
  }
  @IBAction func removeSongMenuAction(_ sender: NSMenuItem) {
    let queuePos = queueView.clickedRow - 1

    if queuePos >= 0 {
      App.store.dispatch(MPDRemoveTrack(queuePos: queuePos))
    }
  }
}

extension QueueViewController: NSOutlineViewDataSource {
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    return dataSource.outlineView(outlineView, numberOfChildrenOfItem: item)
  }

  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return dataSource.outlineView(outlineView, isItemExpandable: item)
  }

  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    return dataSource.outlineView(outlineView, child: index, ofItem: item)
  }

  func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
    return dataSource.outlineView(outlineView, pasteboardWriterForItem: item)
  }

  func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
    return dataSource.outlineView(outlineView, validateDrop: info, proposedItem: item, proposedChildIndex: index)
  }

  func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
    return dataSource.outlineView(outlineView, acceptDrop: info, item: item, childIndex: index)
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
