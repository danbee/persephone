//
//  ArtistViewController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/9/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import ReSwift
import Differ

class ArtistViewController: NSViewController {
  var dataSource = ArtistDataSource()

  @IBOutlet var artistCollectionView: NSCollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    App.store.subscribe(self) {
      $0.select { $0.artistListState }
    }

    NotificationCenter.default.addObserver(self, selector: #selector(didConnect), name: .didConnect, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(willDisconnect), name: .willDisconnect, object: nil)

    artistCollectionView.dataSource = dataSource
  }

  deinit {
    App.store.unsubscribe(self)
  }

  @objc func didConnect() {
    App.mpdClient.fetchAllArtists()
  }

  @objc func willDisconnect() {
    DispatchQueue.main.async {
      App.store.dispatch(UpdateArtistListAction(artists: []))
    }
  }
}

extension ArtistViewController: StoreSubscriber {
  typealias StoreSubscriberStateType = ArtistListState

  func newState(state: StoreSubscriberStateType) {
    let oldArtists = dataSource.artists

    dataSource.artists = state.artists

    artistCollectionView.animateItemChanges(
      oldData: oldArtists,
      newData: dataSource.artists
    )
  }
}
