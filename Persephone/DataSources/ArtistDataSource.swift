//
//  ArtistDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/9/29.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class ArtistDataSource: NSObject, NSCollectionViewDataSource {
  var artists: [String] = []

  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return artists.count
  }

  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(withIdentifier: .artistViewItem, for: indexPath)
    guard let artistViewItem = item as? ArtistViewItem
      else { return item }

    artistViewItem.setArtist(artists[indexPath.item])

    return artistViewItem
  }
}
