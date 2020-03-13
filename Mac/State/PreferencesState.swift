//
//  PreferencesState.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import ReSwift

struct PreferencesState: StateType, Equatable {
  let preferences = UserDefaults.standard

  var mpdServer: MPDServer

  var fetchMissingArtworkFromInternet: Bool

  init() {
    self.mpdServer = MPDServer(
      host: preferences.string(forKey: "mpdHost"),
      port: preferences.value(forKey: "mpdPort") as? Int
    )
    self.fetchMissingArtworkFromInternet = preferences.bool(
      forKey: "fetchMissingArtworkFromInternet"
    )
  }

  func save() {
    preferences.set(mpdServer.host, forKey: "mpdHost")
    if (mpdServer.port.map { $0 > 0 } ?? false) {
      preferences.set(mpdServer.port, forKey: "mpdPort")
    } else {
      preferences.removeObject(forKey: "mpdPort")
    }
    preferences.set(fetchMissingArtworkFromInternet, forKey: "fetchMissingArtworkFromInternet")
  }
}
