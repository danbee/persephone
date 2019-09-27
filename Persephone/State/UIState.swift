//
//  UIState.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/02.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

enum MainWindowState {
  case open
  case closed
  case minimised
}

enum BrowseViewState: Int {
  case artists = 0
  case albums = 1
}

struct UIState: StateType {
  var mainWindowState: MainWindowState = .closed
  var browseViewState: BrowseViewState = .albums

  var databaseUpdating: Bool = false

  var selectedSong: Song?

  var selectedQueueItem: QueueItem?
}
