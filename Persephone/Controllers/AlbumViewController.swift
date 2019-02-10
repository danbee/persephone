//
//  AlbumViewController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumViewController: NSViewController,
                           NSCollectionViewDataSource,
                           NSCollectionViewDelegate {
  var albums: [MPDClient.Album] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateAlbums(_:)),
      name: Notification.loadedAlbums,
      object: AppDelegate.mpdClient
    )
  }

  @objc func updateAlbums(_ notification: Notification) {
    guard let albums = notification.userInfo?[Notification.albumsKey] as? [MPDClient.Album]
      else { return }

    print("Loaded albums")
    self.albums = albums

    albumCollectionView.reloadData()
  }

  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return albums.count
  }

  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(
      withIdentifier: NSUserInterfaceItemIdentifier("AlbumItem"),
      for: indexPath
    )
    guard let albumItem = item as? AlbumItem else { return item }

    albumItem.view.wantsLayer = true
    albumItem.setAlbumTitle(albums[indexPath.item].title)
    albumItem.setAlbumArtist(albums[indexPath.item].artist)

    return albumItem
  }

  @IBOutlet var albumCollectionView: NSCollectionView!
}
