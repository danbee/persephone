//
//  UIReducer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/02.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

func uiReducer(action: Action, state: UIState?) -> UIState {
  var state = state ?? UIState()

  switch action {
  case is MainWindowDidOpenAction:
    state.mainWindowOpen = true

  case is MainWindowDidCloseAction:
    state.mainWindowOpen = false

  case is DatabaseUpdateStartedAction:
    state.databaseUpdating = true

  case is DatabaseUpdateFinishedAction:
    state.databaseUpdating = false

  default:
    break
  }

  return state
}
