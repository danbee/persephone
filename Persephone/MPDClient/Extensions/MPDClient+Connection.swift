//
//  Connection.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func connect(host: String, port: Int) {
    commandQueue.addOperation { [unowned self] in
      guard let connection = mpd_connection_new(host, UInt32(port), 10000),
        mpd_connection_get_error(connection) == MPD_ERROR_SUCCESS
        else { return }

      self.isConnected = true

      guard let status = mpd_run_status(connection)
        else { return }

      self.connection = connection
      self.status = Status(status)

      self.fetchQueue()
      self.fetchAllAlbums()
      self.idle()

      self.delegate?.didConnect(mpdClient: self)
      self.delegate?.didUpdateState(mpdClient: self, state: self.status!.state)
      self.delegate?.didUpdateTime(mpdClient: self, total: self.status!.totalTime, elapsedMs: self.status!.elapsedTimeMs)
      self.delegate?.didUpdateQueue(mpdClient: self, queue: self.queue)
      self.delegate?.didUpdateQueuePos(mpdClient: self, song: self.status!.song)
    }
  }

  func disconnect() {
    guard isConnected else { return }

    noIdle()
    commandQueue.addOperation { [unowned self] in
      self.delegate?.willDisconnect(mpdClient: self)

      mpd_connection_free(self.connection)
      self.isConnected = false
    }
  }
}
