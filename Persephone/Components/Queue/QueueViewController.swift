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

    NotificationCenter.default.addObserver(self, selector: #selector(didConnect), name: .didConnect, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(willDisconnect), name: .willDisconnect, object: nil)

    queueView.dataSource = dataSource
    queueView.columnAutoresizingStyle = .sequentialColumnAutoresizingStyle
    queueView.registerForDraggedTypes([.songPasteboardType, .albumPasteboardType])
    queueView.draggingDestinationFeedbackStyle = .regular
  }

  deinit {
    App.store.unsubscribe(self)
  }

  override func keyDown(with event: NSEvent) {
    switch event.keyCode {
    case NSEvent.keyCodeSpace:
      nextResponder?.keyDown(with: event)
    case NSEvent.keyCodeBS:
      let queuePos = queueView.selectedRow

      App.mpdClient.removeSong(at: queuePos)
    default:
      super.keyDown(with: event)
    }
  }

  @objc func didConnect() {
    App.mpdClient.fetchQueue()
  }

  @objc func willDisconnect() {
    DispatchQueue.main.async {
      App.store.dispatch(UpdateQueuePosAction(queuePos: -1))
      App.store.dispatch(UpdateQueueAction(queue: []))
    }
  }

  @IBAction func playTrack(_ sender: Any) {
    let queuePos = queueView.selectedRow

    App.mpdClient.playTrack(at: queuePos)
  }
  
  @IBAction func playSongMenuAction(_ sender: NSMenuItem) {
    let queuePos = queueView.clickedRow

    App.mpdClient.playTrack(at: queuePos)
  }
  @IBAction func removeSongMenuAction(_ sender: NSMenuItem) {
    let queuePos = queueView.clickedRow

    App.mpdClient.removeSong(at: queuePos)
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
