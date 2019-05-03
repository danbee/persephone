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

struct UIState: StateType {
  var mainWindowState: MainWindowState = .closed

  var databaseUpdating: Bool = false
}
