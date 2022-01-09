//
//  MPDClient+Playlists.swift
//  Persephone
//
//  Created by Dan Barber on 2020-4-24.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func fetchPlaylists() {
    enqueueCommand(command: .fetchPlaylists)
  }

  func saveQueueToPlaylist(name: String) {
    enqueueCommand(
      command: .saveQueueToPlaylist,
      userData: ["name": name]
    )
  }
  
  func loadQueueFromPlaylist(name: String) {
    enqueueCommand(
      command: .loadQueueFromPlaylist,
      userData: ["name": name]
    )
  }
  
  func playlists() {
    var playlists: [MPDPlaylist] = []

    mpd_send_list_playlists(connection)
    
    while let playlist = mpd_recv_playlist(connection) {
      let mpdPlaylist = MPDPlaylist(playlist)
      
      playlists.append(mpdPlaylist)
    }
    
    self.delegate?.didLoadPlaylists(mpdClient: self, playlists: playlists)
  }
  
  func sendSaveQueueToPlaylist(name: String) {
    mpd_run_save(connection, name)
  }
  
  func sendLoadQueueFromPlaylist(name: String) {
    mpd_run_load(connection, name)
  }
}
