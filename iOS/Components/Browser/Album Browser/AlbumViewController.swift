//
//  ViewController.swift
//  Persephone-iOS
//
//  Created by Daniel Barber on 2020-3-13.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit
import ReSwift

class AlbumViewController: UICollectionViewController {
  let dataSource = AlbumDataSource()
  
  let itemsPerRow: CGFloat = 2
  
  let sectionInsets = UIEdgeInsets(
    top: 20.0,
    left: 20.0,
    bottom: 30.0,
    right: 20.0
  )

  override func viewDidLoad() {
    super.viewDidLoad()
    
    albumCollectionView.dataSource = dataSource

    App.store.subscribe(self) {
      $0.select { $0.albumListState }
    }

    NotificationCenter.default.addObserver(self, selector: #selector(didConnect), name: .didConnect, object: nil)
  }

  @objc func didConnect() {
    App.mpdClient.fetchAllAlbums()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let detailView = segue.destination as? AlbumSongListViewController,
      let sender = sender as? AlbumItemCell
      else { return }
    
    detailView.setAlbum(sender.album)
  }
  
  @IBOutlet var albumCollectionView: UICollectionView!
}

extension AlbumViewController: StoreSubscriber {
  typealias StoreSubscriberStateType = AlbumListState

  func newState(state: StoreSubscriberStateType) {
    dataSource.albums = state.albums

    albumCollectionView.reloadData()
  }
}
