//
//  QueueController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/01.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import PromiseKit

class QueueViewController: NSViewController,
                           NSOutlineViewDelegate {
  var dataSource = QueueDataSource()

  @IBOutlet var queueView: NSOutlineView!
  @IBOutlet var queueAlbumArtImage: NSImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    setupNotificationObservers()

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
      AppDelegate.mpdClient.playTrack(at: newQueuePos)
    }
  }

  @objc func stateChanged(_ notification: Notification) {
    guard let state = notification.userInfo?[Notification.stateKey] as? MPDClient.MPDStatus.State
      else { return }

    dataSource.setQueueIcon(state)
  }

  @objc func queueChanged(_ notification: Notification) {
    guard let queue = notification.userInfo?[Notification.queueKey] as? [MPDClient.MPDSong]
      else { return }

    dataSource.updateQueue(queue)
    queueView.reloadData()
  }

  @objc func queuePosChanged(_ notification: Notification) {
    guard let queuePos = notification.userInfo?[Notification.queuePosKey] as? Int
      else { return }

    dataSource.setQueuePos(queuePos)
    queueView.reloadData()
    updateAlbumArt()
  }

  func updateAlbumArt() {
    if let playingQueueItem = dataSource.queue.first(where: { $0.isPlaying }) {
      let albumArtService = AlbumArtService(song: playingQueueItem.song)

      albumArtService.fetchBigAlbumArt()
        .done() {
          guard let image = $0 else { return }

          self.queueAlbumArtImage.image = image.toFitBox(
            size: NSSize(width: 500, height: 500)
          )
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

  func setupNotificationObservers() {
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
}
