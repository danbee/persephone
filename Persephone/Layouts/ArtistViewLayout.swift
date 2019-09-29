//
//  ArtistViewLayout.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/9/29.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class ArtistViewLayout: NSCollectionViewFlowLayout {
  override func prepare() {
    super.prepare()

    guard let collectionView = collectionView
      else { return }

    let width = collectionView.bounds.size.width

    itemSize.width = width
  }
}
