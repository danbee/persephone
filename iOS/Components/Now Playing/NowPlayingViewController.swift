//
//  NowPlayingViewController.swift
//  Persephone-iOS
//
//  Created by Dan Barber on 2020-5-15.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit
import ReSwift
import Kingfisher

class NowPlayingViewController: UIViewController {
  @IBOutlet var separatorHeight: NSLayoutConstraint!
  @IBOutlet var playPauseButton: UIButton!
  @IBOutlet var nextButton: UIButton!
  @IBOutlet var songTitle: UILabel!
  @IBOutlet var albumCoverView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    separatorHeight.constant = 1 / traitCollection.displayScale
    
    App.store.subscribe(self) {
      $0.select { $0.playerState }
    }
  
    NotificationCenter.default.addObserver(self, selector: #selector(didConnect), name: .didConnect, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(willDisconnect), name: .willDisconnect, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(didReloadAlbumArt), name: .didReloadAlbumArt, object: nil)

    albumCoverView.layer.backgroundColor = UIColor.black.cgColor
    albumCoverView.layer.cornerRadius = 4
    albumCoverView.layer.borderWidth = 1 / traitCollection.displayScale
    albumCoverView.layer.masksToBounds = true

    setAppearance()
  }
  
  override func didMove(toParent parent: UIViewController?) {
    super.didMove(toParent: parent)

    preferredContentSize.height = NowPlayingTabBar.barHeight
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    separatorHeight.constant = 1 / traitCollection.displayScale

    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      setAppearance()
    }
  }
  
  func setAppearance() {
    let darkMode = traitCollection.userInterfaceStyle == .dark

    albumCoverView.layer.borderColor = darkMode ? CGColor.albumBorderColorDark : CGColor.albumBorderColorLight
  }

  @objc func didConnect() {
    App.mpdClient.fetchQueue()
  }
  
  @objc func willDisconnect() {
    DispatchQueue.main.async {
      App.store.dispatch(UpdateQueuePosAction(queuePos: -1))
      App.store.dispatch(UpdateQueueAction(queue: []))
    }
  }
  
  @objc func didReloadAlbumArt() {
    // NO-OP
  }

  func setTransportControlState(_ state: PlayerState) {
    guard let state = state.state else { return }
    
    playPauseButton.isEnabled = state.isOneOf([.playing, .paused, .stopped])
    nextButton.isEnabled = state.isOneOf([.playing, .paused])
    
    if state.isOneOf([.paused, .stopped, .unknown]) {
      playPauseButton.setImage(.playIconLarge, for: .normal)
    } else {
      playPauseButton.setImage(.pauseIconLarge, for: .normal)
    }
  }
  
  func setSong(_ song: Song?) {
    guard let song = song else {
      self.songTitle.text = "Not Playing"
      self.albumCoverView.image = .defaultCoverArt
      return
    }
    
    songTitle.text = song.title

    let provider = MPDAlbumArtImageDataProvider(
      songUri: song.mpdSong.uriString,
      cacheKey: song.album.hash
    )

    albumCoverView.kf.setImage(
      with: .provider(provider),
      placeholder: UIImage.defaultCoverArt,
      options: [
        .processor(DownsamplingImageProcessor(size: .queueSongCoverSize)),
        .scaleFactor(traitCollection.displayScale),
      ]
    )
  }
  
  @IBAction func playPauseButtonAction(_ sender: Any) {
    App.mpdClient.playPause()
  }

  @IBAction func nextButtonAction(_ sender: Any) {
    App.mpdClient.nextTrack()
  }
}

extension NowPlayingViewController: StoreSubscriber {
  typealias StoreSubscriberStateType = PlayerState
  
  func newState(state: PlayerState) {
    DispatchQueue.main.async {
      self.setTransportControlState(state)
      self.setSong(state.currentSong)
    }
  }
}
