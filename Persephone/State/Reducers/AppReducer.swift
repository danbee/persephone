//
//  AppReducer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
  return AppState(
    playerState: playerReducer(action: action, state: state?.playerState),
    queueState: queueReducer(action: action, state: state?.queueState),
    albumListState: albumListReducer(action: action, state: state?.albumListState),
    artistListState: artistListReducer(action: action, state: state?.artistListState),
    preferencesState: preferencesReducer(action: action, state: state?.preferencesState),
    uiState: uiReducer(action: action, state: state?.uiState)
  )
}
