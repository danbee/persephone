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
  func createConnection(host: String, port: Int) {
    connection = mpd_connection_new(host, UInt32(port), 10000)
    let error = mpd_connection_get_error(connection)

    guard error == MPD_ERROR_SUCCESS else {
      _ = handleError(mpdError: error)
      return
    }

    self.isConnected = true

    guard let status = mpd_run_status(connection)
      else { return }

    self.status = MPDStatus(status)

    delegate?.didConnect(mpdClient: self)
    delegate?.didUpdateStatus(mpdClient: self, status: self.status!)
  }
  
  func freeConnection() {
    guard isConnected else { return }
    
    self.delegate?.willDisconnect(mpdClient: self)

     mpd_connection_free(self.connection)
     self.isConnected = false
  }

  func connect(host: String, port: Int) {
    let commandOperation = BlockOperation() { [unowned self] in
      self.sendCommand(command: .connect, userData: ["host": host, "port": port])

      if self.isConnected {
        self.idle()
      }
    }
    commandQueue.addOperation(commandOperation)
  }
  
  func disconnect() {
    enqueueCommand(command: .disconnect)
  }
}
