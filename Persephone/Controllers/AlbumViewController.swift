//
//  AlbumViewController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumViewController: NSViewController,
                           NSCollectionViewDelegate,
                           NSCollectionViewDelegateFlowLayout {
  let paddingWidth: CGFloat = 40
  let gutterWidth: CGFloat = 20

  var dataSource = AlbumDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()

    albumScrollView.postsBoundsChangedNotifications = true

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

    albumCollectionView.dataSource = dataSource
  }

  override func viewWillLayout() {
    super.viewWillLayout()

    albumCollectionView.collectionViewLayout?.invalidateLayout()
  }

  override func viewDidLayout() {
    super.viewDidLayout()

    guard let layout = albumCollectionView.collectionViewLayout as? AlbumViewLayout
      else { return }

    layout.setScrollPosition()
  }

  @objc func updateAlbums(_ notification: Notification) {
    guard let albums = notification.userInfo?[Notification.albumsKey] as? [MPDClient.Album]
      else { return }

    dataSource.albums = albums
    albumCollectionView.reloadData()
  }

  @objc func clearAlbums(_ notification: Notification) {
    dataSource.albums = []

    albumCollectionView.reloadData()
  }

  @IBOutlet var albumScrollView: NSScrollView!
  @IBOutlet var albumCollectionView: NSCollectionView!
}
