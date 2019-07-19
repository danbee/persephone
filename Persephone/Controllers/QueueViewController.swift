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

    queueView.dataSource = dataSource
    queueView.columnAutoresizingStyle = .sequentialColumnAutoresizingStyle
    queueView.registerForDraggedTypes([.songPasteboardType, .albumPasteboardType])
    queueView.draggingDestinationFeedbackStyle = .regular
  }

  override func keyDown(with event: NSEvent) {
    switch event.keyCode {
    case NSEvent.keyCodeSpace:
      nextResponder?.keyDown(with: event)
    case NSEvent.keyCodeBS:
      let queuePos = queueView.selectedRow - 1

      if queuePos >= 0 {
        App.mpdClient.removeSong(at: queuePos)
      }
    default:
      super.keyDown(with: event)
    }
  }

  @IBAction func playTrack(_ sender: Any) {
    let queuePos = queueView.selectedRow - 1

    if queuePos >= 0 {
      App.mpdClient.playTrack(at: queuePos)
    }
  }
  
  @IBAction func playSongMenuAction(_ sender: NSMenuItem) {
    let queuePos = queueView.clickedRow - 1

    if queuePos >= 0 {
      App.mpdClient.playTrack(at: queuePos)
    }
  }
  @IBAction func removeSongMenuAction(_ sender: NSMenuItem) {
    let queuePos = queueView.clickedRow - 1

    if queuePos >= 0 {
      App.mpdClient.removeSong(at: queuePos)
    }
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
