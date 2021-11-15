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
    guard isConnected else { return }
    
    if isIdle {
      mpd_send_noidle(connection)
    }
  }

  func idle(_ force: Bool = false) {
    guard isConnected else { return }

    let shouldIdle: Bool = (!isIdle && commandQueue.operationCount == 1) || force
    
    if shouldIdle {
      self.isIdle = true
      mpd_send_idle(connection)
      
      let handleIdleOperation = BlockOperation() { [unowned self] in
        self.handleIdleResult()
      }
      
      handleIdleOperation.queuePriority = .high
      commandQueue.addOperation(handleIdleOperation)
    }
  }

  func handleIdleResult() {
    let result = mpd_recv_idle(connection, true)
    let mpdIdle = MPDIdle(rawValue: result.rawValue)
    
    isIdle = false

    if checkError() {
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
      if mpdIdle.contains(.player) ||
         mpdIdle.contains(.options) ||
         mpdIdle.contains(.mixer) {
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
