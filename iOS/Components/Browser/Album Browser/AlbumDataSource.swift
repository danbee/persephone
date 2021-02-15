//
//  AlbumDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import UIKit

class AlbumDataSource: NSObject, UICollectionViewDataSource {
  var albums: [Album] = []

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return albums.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumViewCell", for: indexPath)
    guard let albumViewCell = item as? AlbumItemCell else { return item }

    albumViewCell.setAlbum(albums[indexPath.item])

    return albumViewCell
  }
}
