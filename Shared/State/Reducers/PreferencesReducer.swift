//
//  PreferencesReducer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/28.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation
import ReSwift

func preferencesReducer(action: Action, state: PreferencesState?) -> PreferencesState {

  var state = state ?? PreferencesState()

  switch action {
  case let action as UpdateServerHost:
    state.mpdServer.host = action.host

  case let action as UpdateServerPort:
    state.mpdServer.port = action.port
  
  case let action as UpdateCustomArtworkURLToggle:
    state.fetchArtworkFromCustomURL = action.useCustomArtworkURL

  case is SavePreferences:
    state.save()

  default:
    break
  }

  return state
}
