//
//  AlbumDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumDataSource: NSObject, NSCollectionViewDataSource {
  var albums: [MPDClient.Album] = []

  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return albums.count
  }

  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(withIdentifier: .albumItem, for: indexPath)
    guard let albumItem = item as? AlbumItem else { return item }

    albumItem.view.wantsLayer = true
    albumItem.setAlbum(albums[indexPath.item])

    return albumItem
  }
}
