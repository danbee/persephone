//
//  AlbumViewLayout.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/18.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumViewLayout: NSCollectionViewFlowLayout {
  let maxItemWidth: CGFloat = 180
  let albumInfoHeight: CGFloat = 39

  required init?(coder aDecoder: NSCoder) {
    super.init()

    minimumLineSpacing = 20
    minimumInteritemSpacing = 20
    sectionInset = NSEdgeInsets(
      top: 20,
      left: 40,
      bottom: 60,
      right: 40
    )
  }

  override func prepare() {
    super.prepare()

    guard let collectionView = collectionView
      else { return }

    let width = collectionView.bounds.size.width
    var divider: CGFloat = 1
    var itemWidth: CGFloat = 0

    repeat {
      let totalPaddingWidth = sectionInset.left + sectionInset.right
      let totalGutterWidth = (divider - 1) * (minimumInteritemSpacing)
      itemWidth = (width - totalPaddingWidth - totalGutterWidth - 1) / divider
      divider = divider + 1
    } while itemWidth > maxItemWidth

    let itemHeight = itemWidth + albumInfoHeight

    itemSize = NSSize(width: itemWidth, height: itemHeight)
  }
}
