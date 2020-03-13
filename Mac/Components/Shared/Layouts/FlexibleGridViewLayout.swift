//
//  AlbumViewLayout.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/18.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class FlexibleGridViewLayout: NSCollectionViewFlowLayout {
  let maxItemWidth: CGFloat = 200
  var extraHeight: CGFloat = 0
  var scrollPosition: CGFloat = 0

  required init?(coder aDecoder: NSCoder) {
    super.init()

    minimumLineSpacing = 0
    minimumInteritemSpacing = 0
    sectionInset = NSEdgeInsets(
      top: 10,
      left: 30,
      bottom: 50,
      right: 30
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

    let itemHeight = itemWidth + extraHeight

    itemSize = NSSize(width: itemWidth, height: itemHeight)
  }

  func saveScrollPosition() {
    guard let collectionView = collectionView
      else { return }

    if let scrollView = collectionView.enclosingScrollView {
      scrollPosition = scrollView.documentVisibleRect.minY / collectionView.bounds.height
    }
  }

  func setScrollPosition() {
    guard let collectionView = collectionView
      else { return }

    collectionView.scroll(NSPoint(x: 0, y: scrollPosition * collectionView.bounds.height))
  }
}
