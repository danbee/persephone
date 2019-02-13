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
  var albumWidth: CGFloat = 0
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
  }

  override func viewWillLayout() {
    super.viewWillLayout()

    albumCollectionView.collectionViewLayout?.invalidateLayout()
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
    albumItem.setAlbum(albums[indexPath.item])

    return albumItem
  }

  func collectionView(_ collectionView: NSCollectionView, layout: NSCollectionViewLayout, sizeForItemAt: IndexPath) -> NSSize {
    let width = collectionView.frame.size.width
    var divider: CGFloat = 1
    var itemWidth: CGFloat = 0

    repeat {
      let totalPaddingWidth = paddingWidth * 2
      let totalGutterWidth = (divider - 1) * (gutterWidth + 1)
      itemWidth = (width - totalPaddingWidth - totalGutterWidth) / divider
      divider = divider + 1
    } while itemWidth > 180

    let itemHeight = itemWidth + 39

    return NSSize(width: itemWidth, height: itemHeight)
  }

  @IBOutlet var albumCollectionView: NSCollectionView!
}
