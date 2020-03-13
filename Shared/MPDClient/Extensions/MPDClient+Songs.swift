//
//  MPDClient+Songs.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/7/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func fetchAlbumArt(
    songUri: String,
    imageData: Data?,
    offset: Int32 = 0,
    callback: @escaping (Data?) -> Void
  ) {
    enqueueCommand(
      command: .fetchAlbumArt,
      priority: .low,
      userData: [
        "songUri": songUri,
        "callback": callback,
        "imageData": imageData as Any,
        "offset": offset,
      ]
    )
  }
  
  func searchSongs(_ terms: [MPDClient.MPDTag: String]) -> [MPDSong] {
    var songs: [MPDSong] = []

    mpd_search_db_songs(connection, true)
    for (tag, term) in terms {
      mpd_search_add_tag_constraint(connection, MPD_OPERATOR_DEFAULT, tag.mpdTag(), term)
    }
    mpd_search_commit(connection)

    while let song = mpd_recv_song(connection) {
      songs.append(MPDSong(song))
    }

    return songs
  }
  
  func sendFetchAlbumArt(
    forUri songUri: String,
    imageData: Data?,
    offset: Int32,
    callback: @escaping (Data?) -> Void
  ) -> Void {
    var size: Int?
    
    mpd_send_albumart(connection, songUri, String(offset))
    
    guard let sizePair = mpd_recv_pair(connection) else {
      mpd_connection_clear_error(connection)
      return
    }
    size = Int(MPDPair(sizePair).value)
    mpd_return_pair(connection, sizePair)

    var data = imageData ?? Data(count: size!)
          
    let binaryPair = MPDPair(mpd_recv_pair(connection))
    let chunkSize = Int(binaryPair.value)!
    mpd_return_pair(connection, binaryPair.pair)
    
    _ = data[offset...].withUnsafeMutableBytes { (pointer) in
      mpd_recv_binary(connection, pointer.baseAddress, chunkSize)
    }
    
    guard mpd_response_finish(connection) else { return }
    
    let newOffset = offset + Int32(chunkSize)
    
    if newOffset < size! {
      fetchAlbumArt(
        songUri: songUri,
        imageData: data,
        offset: newOffset,
        callback: callback
      )
    } else {
      callback(data)
    }
  }
}
