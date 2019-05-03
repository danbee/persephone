//
//  UIState.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/5/02.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import ReSwift

struct UIState: StateType {
  var mainWindowOpen: Bool = false
  var databaseUpdating: Bool = false
}
