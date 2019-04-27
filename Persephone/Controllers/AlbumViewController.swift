//
//  AlbumViewController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import ReSwift
import Differ

class AlbumViewController: NSViewController,
                           NSCollectionViewDelegate,
                           NSCollectionViewDelegateFlowLayout,
                           StoreSubscriber {
  typealias StoreSubscriberStateType = AlbumListState

  var preferences = Preferences()

  let paddingWidth: CGFloat = 40
  let gutterWidth: CGFloat = 20

  var dataSource = AlbumDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()

    AppDelegate.store.subscribe(self) {
      (subscription: Subscription<AppState>) -> Subscription<AlbumListState> in

      subscription.select { state -> AlbumListState in state.albumListState }
    }

    albumScrollView.postsBoundsChangedNotifications = true

    albumCollectionView.dataSource = dataSource

    preferences.addObserver(self, forKeyPath: "mpdLibraryDir")
    preferences.addObserver(self, forKeyPath: "fetchMissingArtworkFromInternet")
  }

  override func viewWillDisappear() {
    super.viewWillDisappear()

    AppDelegate.store.unsubscribe(self)
  }

  override func viewWillLayout() {
    super.viewWillLayout()

    if let layout = albumCollectionView.collectionViewLayout as? AlbumViewLayout {
      layout.saveScrollPosition()
    }

    albumCollectionView.collectionViewLayout?.invalidateLayout()
  }

  override func viewDidLayout() {
    super.viewDidLayout()

    guard let layout = albumCollectionView.collectionViewLayout as? AlbumViewLayout
      else { return }

    layout.setScrollPosition()
  }

  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?
    ) {
    switch keyPath {
    case "mpdLibraryDir":
      albumCollectionView.reloadData()
    case "fetchMissingArtworkFromInternet":
      // dataSource.resetCoverArt()
      albumCollectionView.reloadData()
    default:
      break
    }
  }

  func newState(state: StoreSubscriberStateType) {
    print("New album list state")
    if dataSource.albums == [] {
      dataSource.albums = state.albums
      albumCollectionView.reloadData()
    } else {
      let oldAlbums = dataSource.albums
      dataSource.albums = state.albums
      albumCollectionView.animateItemChanges(
        oldData: oldAlbums,
        newData: dataSource.albums
      )
    }
  }

  @IBOutlet var albumScrollView: NSScrollView!
  @IBOutlet var albumCollectionView: NSCollectionView!
}
