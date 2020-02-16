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
    do {
      idleLock.lock()
      defer { idleLock.unlock() }
      if isIdle {
        mpd_send_noidle(connection)
        isIdle = false
      }
    }
  }

  func idle(_ force: Bool = false) {
    let shouldIdle: Bool
  
    do {
      idleLock.lock()
      defer { idleLock.unlock() }
      shouldIdle = (!isIdle && commandQueue.operationCount == 1) || force
      if shouldIdle {
        mpd_send_idle(connection)
        self.isIdle = true
      }
    }
    
    // noIdle could happen here which will crash

    if shouldIdle {
      let result = mpd_recv_idle(connection, true)
      handleIdleResult(result)
    }
  }

  func handleIdleResult(_ result: mpd_idle) {
    let mpdIdle = MPDIdle(rawValue: result.rawValue)

    do {
      idleLock.lock()
      defer { idleLock.unlock() }

      if isIdle {
        isIdle = false
      
        if mpdIdle.contains(.database) {
          self.fetchAllAlbums()
        }
        if mpdIdle.contains(.queue) {
          self.fetchQueue()
          self.fetchStatus()

          self.delegate?.didUpdateQueue(mpdClient: self, queue: self.queue)
          if let status = self.status {
            self.delegate?.didUpdateQueuePos(mpdClient: self, song: status.song)
          }
        }
        if mpdIdle.contains(.player) || mpdIdle.contains(.options) {
          self.fetchStatus()

          if let status = self.status {
            self.delegate?.didUpdateStatus(mpdClient: self, status: status)
            self.delegate?.didUpdateQueuePos(mpdClient: self, song: status.song)
          }
        }
        if mpdIdle.contains(.update) {
          self.fetchStatus()

          if self.status?.updating ?? false {
            self.delegate?.willStartDatabaseUpdate(mpdClient: self)
          } else {
            self.delegate?.didFinishDatabaseUpdate(mpdClient: self)
          }
        }

        if !mpdIdle.isEmpty {
          self.idle()
        }
      }
    }
  }
}
