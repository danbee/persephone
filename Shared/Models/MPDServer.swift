//
//  MPDServer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

struct MPDServer {
  #if os(macOS)
  let hostDefault: String? = "127.0.0.1"
  #else
  let hostDefault: String? = nil
  #endif

  let portDefault = 6600

  var host: String?

  var hostOrDefault: String? {
    return host ?? hostDefault
  }

  var port: Int?

  var portOrDefault: Int {
    return port ?? portDefault
  }
}

extension MPDServer: Equatable {
  static func == (lhs: MPDServer, rhs: MPDServer) -> Bool {
    return lhs.host == rhs.host &&
      lhs.port == rhs.port
  }
}
