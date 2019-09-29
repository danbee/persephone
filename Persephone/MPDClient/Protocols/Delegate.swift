//
//  MPDClientDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/01.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

protocol MPDClientDelegate {
  func didConnect(mpdClient: MPDClient)
  func willDisconnect(mpdClient: MPDClient)

  func didUpdateStatus(mpdClient: MPDClient, status: MPDClient.MPDStatus)

  func willStartDatabaseUpdate(mpdClient: MPDClient)
  func didFinishDatabaseUpdate(mpdClient: MPDClient)

  func didUpdateQueue(mpdClient: MPDClient, queue: [MPDClient.MPDSong])
  func didUpdateQueuePos(mpdClient: MPDClient, song: Int)
  
  func didLoadAlbums(mpdClient: MPDClient, albums: [MPDClient.MPDAlbum])

  func didLoadArtists(mpdClient: MPDClient, artists: [String])
}
