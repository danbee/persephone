//
//  MediaInfoController.swift
//  Persephone
//
//  Created by Alan Harper on 18/11/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import Foundation
import ReSwift
import MediaPlayer
import Kingfisher

class PlayerStateInfoController {
  init() {
    App.store.subscribe(self) {
      $0.select { $0.playerState.state }
    }
    let commandCenter = MPRemoteCommandCenter.shared()
    commandCenter.playCommand.addTarget {  _ in
      App.mpdClient.playPause()
      return .success
    }
    commandCenter.togglePlayPauseCommand.addTarget { _ in
      App.mpdClient.playPause()
      return .success
    }
    commandCenter.pauseCommand.addTarget { _ in
      App.mpdClient.playPause()
      return .success
    }

    commandCenter.nextTrackCommand.addTarget {  _ in
      App.mpdClient.nextTrack()
      return .success
    }
    
    commandCenter.previousTrackCommand.addTarget { _ in
      App.mpdClient.prevTrack()
      return .success
    }
  }

  func notifyState(_ state: MPDClient.MPDStatus.State?) {
    let infoCenter = MPNowPlayingInfoCenter.default()

    switch(state) {
    case .unknown:
      infoCenter.playbackState = .unknown
      break;
    case .paused:
      infoCenter.playbackState = .paused
      break;
    case .stopped:
      infoCenter.playbackState = .stopped
      break;
    case .playing:
      infoCenter.playbackState = .playing
      break;
    case .none:
      return
    }
  }
}

extension PlayerStateInfoController: StoreSubscriber {
  typealias StoreSubscriberStateType = MPDClient.MPDStatus.State?

  func newState(state: StoreSubscriberStateType) {
    notifyState(state)
  }
}
