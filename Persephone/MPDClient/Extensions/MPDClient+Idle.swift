//
//  Idle.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import mpdclient

extension MPDClient {
  func noIdle() {
    if isIdle {
      mpd_send_noidle(connection)
      isIdle = false
    }
  }

  func idle() {
    if !self.isIdle && self.commandsQueued == 0 {
      mpd_send_idle(self.connection)
      self.isIdle = true

      let result = mpd_recv_idle(self.connection, true)
      self.handleIdleResult(result)
    }
  }

  func handleIdleResult(_ result: mpd_idle) {
    isIdle = false
    
    let mpdIdle = Idle(rawValue: result.rawValue)

    if mpdIdle.contains(.queue) {
      self.fetchQueue()
      self.delegate?.didUpdateQueue(mpdClient: self, queue: self.queue)
    }
    if mpdIdle.contains(.player) {
      self.fetchStatus()

      if let status = self.status {
        self.delegate?.didUpdateState(mpdClient: self, state: status.state)
        self.delegate?.didUpdateTime(mpdClient: self, total: status.totalTime, elapsedMs: status.elapsedTimeMs)
        self.delegate?.didUpdateQueuePos(mpdClient: self, song: status.song)
      }
    }
    if !mpdIdle.isEmpty {
      self.idle()
    }
  }
}
