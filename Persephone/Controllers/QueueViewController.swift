//
//  QueueController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/01.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import ReSwift

class QueueViewController: NSViewController,
                           NSOutlineViewDelegate,
                           StoreSubscriber {
  typealias StoreSubscriberStateType = QueueState

  var dataSource = QueueDataSource()

  @IBOutlet var queueView: NSOutlineView!
  @IBOutlet var queueAlbumArtImage: NSImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    AppDelegate.store.subscribe(self) {
      (subscription: Subscription<AppState>) -> Subscription<QueueState> in

      subscription.select { state in state.queueState }
    }

    queueView.dataSource = dataSource
    queueView.columnAutoresizingStyle = .sequentialColumnAutoresizingStyle
  }

  override func viewWillDisappear() {
    super.viewWillDisappear()

    AppDelegate.store.unsubscribe(self)
  }
  
  func newState(state: StoreSubscriberStateType) {
    dataSource.setQueueIcon()
    queueView.reloadData()
    updateAlbumArt(state)
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
      AppDelegate.mpdClient.playTrack(at: newQueuePos)
    }
  }

  func notifyTrack(_ state: QueueState) {
    guard let currentSong = state.currentSong,
      let status = AppDelegate.mpdClient.status,
      status.state == .playing
    else { return }

    SongNotifierService(song: currentSong, image: queueAlbumArtImage.image)
      .deliver()
  }

  func updateAlbumArt(_ state: QueueState) {
    if let playingQueueItem = state.queue.first(
      where: { $0.isPlaying }
    ) {
      let albumArtService = AlbumArtService(song: playingQueueItem.song)

      albumArtService.fetchBigAlbumArt()
        .done() {
          if let image = $0 {
            self.queueAlbumArtImage.image = image
          } else {
            self.queueAlbumArtImage.image = NSImage.defaultCoverArt
          }

          self.notifyTrack(state)
        }
        .cauterize()
    } else {
      queueAlbumArtImage.image = NSImage.defaultCoverArt
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
