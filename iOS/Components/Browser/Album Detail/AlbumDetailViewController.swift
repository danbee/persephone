//
//  AlbumDetailController.swift
//  Persephone-iOS
//
//  Created by Daniel Barber on 2020-3-29.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit
import Kingfisher

class AlbumDetailViewController: UIViewController {
  var album: Album?
  var albumSongs: [Song] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never

    albumCoverView.layer.backgroundColor = UIColor.black.cgColor
    albumCoverView.layer.cornerRadius = 4
    albumCoverView.layer.borderWidth = 0.5
    albumCoverView.layer.masksToBounds = true
    
    playAlbumButton.layer.cornerRadius = 8
    setAppearance()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    guard let album = album else { return }

    albumTitle.text = album.title
    albumArtist.text = album.artist

    getAlbumSongs(for: album)
  }
  
  func setAlbum(_ album: Album?) {
    guard let album = album else { return }

    self.album = album
  }
  
  func getAlbumSongs(for album: Album) {
    App.mpdClient.getAlbumSongs(for: album.mpdAlbum) { [weak self] (mpdSongs: [MPDClient.MPDSong]) in
      guard let self = self else { return }

      DispatchQueue.main.async {
        self.albumSongs = mpdSongs.map { Song(mpdSong: $0) }

        //self.albumTracksView.reloadData()

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
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    setAppearance()
  }
  
  func setAppearance() {
    let darkMode = traitCollection.userInterfaceStyle == .dark

    albumCoverView.layer.borderColor = darkMode ? CGColor.albumBorderColorDark : CGColor.albumBorderColorLight
  }

  @IBAction func playAlbumAction(_ sender: Any) {
    guard let album = album else { return }
    
    App.mpdClient.playAlbum(album.mpdAlbum)
  }
  
  @IBOutlet var playAlbumButton: UIButton!
  @IBOutlet var albumCoverView: UIImageView!
  @IBOutlet var albumTitle: UILabel!
  @IBOutlet var albumArtist: UILabel!
}
