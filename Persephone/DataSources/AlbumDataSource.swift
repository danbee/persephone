//
//  AlbumDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import PromiseKit

class AlbumDataSource: NSObject, NSCollectionViewDataSource {
  var albums: [Album] = []

  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return albums.count
  }

  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(withIdentifier: .albumViewItem, for: indexPath)
    guard let albumViewItem = item as? AlbumViewItem else { return item }

    albumViewItem.view.wantsLayer = true
    albumViewItem.setAlbum(albums[indexPath.item])

    switch albums[indexPath.item].coverArt {
    case .notLoaded:
      App.mpdClient.getAlbumFirstSong(for: albums[indexPath.item].mpdAlbum) {
        guard let song = $0 else { return }

        CoverArtService(song: Song(mpdSong: song))
          .fetchCoverArt()
          .done { image in
            DispatchQueue.main.async {
              App.store.dispatch(
                UpdateCoverArtAction(coverArt: image, albumIndex: indexPath.item)
              )
            }
          }
      }
    default:
       break
    }

    return albumViewItem
  }
}
