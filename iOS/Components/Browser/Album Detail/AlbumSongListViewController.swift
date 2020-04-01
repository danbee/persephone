//
//  AlbumSongListViewController.swift
//  Persephone
//
//  Created by Daniel Barber on 2020-3-30.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumSongListViewController: UITableViewController {
  var album: Album?
  var albumSongs: [Song] = []
  var dataSource = AlbumTracksDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    albumTracksView.dataSource = dataSource
    albumTracksView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    navigationItem.largeTitleDisplayMode = .never
    
    albumCoverView.layer.backgroundColor = UIColor.black.cgColor
    albumCoverView.layer.cornerRadius = 4
    albumCoverView.layer.borderWidth = 0.5
    albumCoverView.layer.masksToBounds = true

    playAlbumButton.layer.cornerRadius = 8
    addAlbumToQueueButton.layer.cornerRadius = 8
    setAppearance()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    guard let album = album else { return }
    
    getAlbumSongs(for: album)

    albumTitle.text = album.title
    albumMetadata.text = "\(album.artist) · \(album.date)"

    var layoutSize = UIView.layoutFittingExpandedSize
    layoutSize.width = UIScreen.main.bounds.width

    let headerViewSize = albumTracksView.tableHeaderView?
      .systemLayoutSizeFitting(
        layoutSize,
        withHorizontalFittingPriority: .defaultHigh,
        verticalFittingPriority: .defaultLow
    )
    
    albumTracksView.tableHeaderView?.frame.size = headerViewSize!
  }
  
  func setAlbum(_ album: Album?) {
    guard let album = album else { return }

    self.album = album
  }

  func getAlbumSongs(for album: Album) {
    App.mpdClient.getAlbumSongs(for: album.mpdAlbum) { [weak self] (mpdSongs: [MPDClient.MPDSong]) in
      guard let self = self else { return }

      DispatchQueue.main.async {
        self.dataSource.setAlbumSongs(
          mpdSongs.map { Song(mpdSong: $0) }
        )

        self.albumTracksView.reloadData()

        guard let mpdSong = album.mpdAlbum.firstSong
          else { return }
        
        self.getBigCoverArt(song: Song(mpdSong: mpdSong), album: album)
      }
    }
  }
  
  func getBigCoverArt(song: Song, album: Album) {
    let provider = MPDAlbumArtImageDataProvider(
      songUri: song.mpdSong.uriString,
      cacheKey: album.hash
    )

    albumCoverView.kf.setImage(
      with: .provider(provider),
      placeholder: UIImage(named: "defaultCoverArt"),
      options: [
        .processor(DownsamplingImageProcessor(size: .albumDetailCoverSize)),
        .scaleFactor(traitCollection.displayScale),
      ]
    )
  }
  
  func setAppearance() {
    let darkMode = traitCollection.userInterfaceStyle == .dark

    albumCoverView.layer.borderColor = darkMode ? CGColor.albumBorderColorDark : CGColor.albumBorderColorLight
  }

  @IBAction func playAlbumAction(_ sender: Any) {
    guard let album = album else { return }

    App.mpdClient.playAlbum(album.mpdAlbum)
  }

  @IBAction func addAlbumToQueueAction(_ sender: Any) {
    guard let album = album else { return }

    let queueLength = App.store.state.queueState.queue.count

    App.mpdClient.addAlbumToQueue(album: album.mpdAlbum, at: queueLength)
  }

  @IBOutlet var addAlbumToQueueButton: UIButton!
  @IBOutlet var playAlbumButton: UIButton!
  @IBOutlet var albumTitle: UILabel!
  @IBOutlet var albumMetadata: UILabel!

  @IBOutlet var albumCoverView: UIImageView!
  @IBOutlet var albumTracksView: UITableView!
}
