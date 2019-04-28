//
//  PreferencesActions.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

struct UpdateServerHost: Action {
  var host: String?
}

struct UpdateServerPort: Action {
  var port: Int?
}

struct UpdateMPDLibraryDir: Action {
  var mpdLibraryDir: String?
}

struct UpdateFetchMissingArtworkFromInternet: Action {
  var fetchMissingArtworkFromInternet: Bool
}

struct SavePreferences: Action {}
