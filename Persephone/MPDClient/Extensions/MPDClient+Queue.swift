//
//  Queue.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func fetchQueue() {
    sendCommand(command: .fetchQueue)
  }

  func playTrack(queuePos: Int) {
    guard isConnected else { return }

    noIdle()
    let commandOperation = BlockOperation { [unowned self] in
      mpd_run_play_pos(self.connection, UInt32(queuePos))
    }
    commandOperation.queuePriority = .veryHigh
    commandQueue.addOperation(commandOperation)
    idle()
  }

  func sendFetchQueue() {
    self.queue = []
    mpd_send_list_queue_meta(connection)

    while let mpdSong = mpd_recv_song(connection) {
      let song = Song(mpdSong)
      self.queue.append(song)
    }
  }
}
