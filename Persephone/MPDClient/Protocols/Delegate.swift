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

  func didUpdateState(mpdClient: MPDClient, state: MPDClient.Status.State)
  func didUpdateTime(mpdClient: MPDClient, total: UInt, elapsedMs: UInt)

  func willUpdateDatabase(mpdClient: MPDClient)
  func didUpdateDatabase(mpdClient: MPDClient)

  func didUpdateQueue(mpdClient: MPDClient, queue: [MPDClient.Song])
  func didUpdateQueuePos(mpdClient: MPDClient, song: Int)
  
  func didLoadAlbums(mpdClient: MPDClient, albums: [MPDClient.Album])
}
