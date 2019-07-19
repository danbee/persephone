//
//  AlbumViewController+NSCollectionViewDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

extension AlbumViewController: NSCollectionViewDelegate {
  func registerForDragAndDrop(_ collectionView: NSCollectionView) {
    collectionView.registerForDraggedTypes([.albumPasteboardType])
    collectionView.setDraggingSourceOperationMask(.copy, forLocal: true)
  }

  func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt index: Int) -> NSPasteboardWriting? {
    let album = dataSource.albums[index]

    return NSPasteboardItem(
      draggedAlbum: DraggedAlbum(
        title: album.title,
        artist: album.artist
      ),
      ofType: .albumPasteboardType
    )
  }

  func collectionView(_ collectionView: NSCollectionView, canDragItemsAt indexes: IndexSet, with event: NSEvent) -> Bool {
    return true
  }
}
