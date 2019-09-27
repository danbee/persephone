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
    state.mainWindowState = .open

  case is MainWindowDidCloseAction:
    state.mainWindowState = .closed

  case is MainWindowDidMinimizeAction:
    state.mainWindowState = .minimised

  case is DatabaseUpdateStartedAction:
    state.databaseUpdating = true

  case is DatabaseUpdateFinishedAction:
    state.databaseUpdating = false

  case let action as SetVisibleBrowseView:
    state.browseViewState = action.browseViewState

  case let action as SetSelectedSong:
    state.selectedSong = action.selectedSong

  case let action as SetSelectedQueueItem:
    state.selectedQueueItem = action.selectedQueueItem

  default:
    break
  }

  return state
}
