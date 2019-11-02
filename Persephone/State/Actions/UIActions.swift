//
//  UIActions.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/02.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

struct MainWindowDidOpenAction: Action {}

struct MainWindowDidCloseAction: Action {}

struct MainWindowDidMinimizeAction: Action {}

struct DatabaseUpdateStartedAction: Action {}

struct DatabaseUpdateFinishedAction: Action {}

struct SetSelectedQueueItem: Action {
  let selectedQueueItem: QueueItem?
}

struct SetSelectedSong: Action {
  let selectedSong: Song?
}

struct SetSearchQuery: Action {
  let searchQuery: String
}
