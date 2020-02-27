//
//  ServerReducer.swift
//  Persephone
//
//  Created by Daniel Barber on 2/26/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import ReSwift

func serverReducer(action: Action, state: ServerState?) -> ServerState {
  var state = state ?? ServerState()
  
  switch action {
  case let action as UpdateConnectedState:
    state.connected = action.connected

  default:
    break
  }
  
  return state
}
