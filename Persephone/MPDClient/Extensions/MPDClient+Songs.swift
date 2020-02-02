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

    mpd_search_db_songs(self.connection, true)
    for (tag, term) in terms {
      mpd_search_add_tag_constraint(self.connection, MPD_OPERATOR_DEFAULT, tag.mpdTag(), term)
    }
    mpd_search_commit(self.connection)

    while let song = mpd_recv_song(self.connection) {
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
    
    mpd_send_albumart(self.connection, songUri, String(offset))
    
    guard let sizePair = mpd_recv_pair(self.connection) else {
      mpd_connection_clear_error(self.connection)
      return
    }
    size = Int(MPDPair(sizePair).value)
    mpd_return_pair(self.connection, sizePair)

    var data = imageData ?? Data(count: size!)
          
    let binaryPair = MPDPair(mpd_recv_pair(self.connection))
    let chunkSize = Int(binaryPair.value)!
    mpd_return_pair(self.connection, binaryPair.pair)
    
    _ = data[offset...].withUnsafeMutableBytes { (pointer) in
      mpd_recv_binary(self.connection, pointer, chunkSize)
    }
    
    guard mpd_response_finish(self.connection) else { return }
    
    let newOffset = offset + Int32(chunkSize)
    
    if newOffset < size! {
      DispatchQueue.main.async {
        self.fetchAlbumArt(
          songUri: songUri,
          imageData: data,
          offset: newOffset,
          callback: callback
        )
      }
    } else {
      DispatchQueue.main.async {
        callback(data)
      }
    }
  }
}
