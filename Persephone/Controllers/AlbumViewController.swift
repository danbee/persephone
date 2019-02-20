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
                           NSCollectionViewDelegate,
                           NSCollectionViewDelegateFlowLayout {
  var albums: [MPDClient.Album] = []
  let paddingWidth: CGFloat = 40
  let gutterWidth: CGFloat = 20

  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updateAlbums(_:)),
      name: Notification.loadedAlbums,
      object: AppDelegate.mpdClient
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(clearAlbums(_:)),
      name: Notification.willDisconnect,
      object: AppDelegate.mpdClient
    )
  }

  override func viewWillLayout() {
    super.viewWillLayout()

    albumCollectionView.collectionViewLayout?.invalidateLayout()
  }

  @objc func updateAlbums(_ notification: Notification) {
    guard let albums = notification.userInfo?[Notification.albumsKey] as? [MPDClient.Album]
      else { return }

    self.albums = albums

    albumCollectionView.reloadData()
  }

  @objc func clearAlbums(_ notification: Notification) {
    self.albums = []

    albumCollectionView.reloadData()
  }

  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return albums.count
  }

  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let item = collectionView.makeItem(withIdentifier: .albumItem, for: indexPath)
    guard let albumItem = item as? AlbumItem else { return item }

    albumItem.view.wantsLayer = true
    albumItem.setAlbum(albums[indexPath.item])

    return albumItem
  }

  @IBOutlet var albumCollectionView: NSCollectionView!
}
