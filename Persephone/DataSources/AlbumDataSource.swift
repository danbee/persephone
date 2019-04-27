//
//  AlbumDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import PromiseKit

class AlbumDataSource: NSObject, NSCollectionViewDataSource {
  var albums: [Album] = []

  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return albums.count
  }
//
//  func resetCoverArt() {
//    albums = AppDelegate.store.state.albumListState.albums.map {
//      var album = $0
//      album.coverArtFetched = false
//      return album
//    }
//  }

  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(withIdentifier: .albumViewItem, for: indexPath)
    guard let albumViewItem = item as? AlbumViewItem else { return item }

    albumViewItem.view.wantsLayer = true
    albumViewItem.setAlbum(albums[indexPath.item])

    switch albums[indexPath.item].coverArt {
    case .notAsked:
      AppDelegate.mpdClient.getAlbumFirstSong(for: albums[indexPath.item].mpdAlbum) {
        guard let song = $0 else { return }

        AlbumArtService(song: Song(mpdSong: song))
          .fetchAlbumArt()
          .done { image in
            DispatchQueue.main.async {
              AppDelegate.store.dispatch(
                UpdateAlbumArt(coverArt: image, albumIndex: indexPath.item)
              )
              //collectionView.reloadItems(at: [indexPath])
            }
          }
      }
    default:
       break
    }

    return albumViewItem
  }
}
