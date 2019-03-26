//
//  AlbumDataSource.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

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

    if albums[indexPath.item].coverArt == nil {
      AppDelegate.mpdClient.albumFirstSong(for: albums[indexPath.item].mpdAlbum) {
        guard let song = $0 else { return }
        
        AlbumArtService(song: Song(mpdSong: song)).fetchAlbumArt { image in
          self.albums[indexPath.item].coverArt = image

          DispatchQueue.main.async {
            collectionView.reloadItems(at: [indexPath])
          }
        }
      }
    }

    return albumViewItem
  }
}
