//
//  AlbumDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import UIKit

extension AlbumViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return albums.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumViewCell", for: indexPath)
    guard let albumViewCell = item as? AlbumItemCell else { return item }

    //albumViewItem.view.wantsLayer = true
    albumViewCell.setAlbum(albums[indexPath.item])

    return albumViewCell
  }
//
//  override func indexTitles(for collectionView: UICollectionView) -> [String]? {
//    return ["#"]
//  }
//
//  override func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
//    return IndexPath(index: 0)
//  }
}
