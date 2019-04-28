//
//  Loading.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/27.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

enum Loading<T> {
  case notLoaded
  case loading
  case loaded(T)
  case error(Error)
}

extension Loading: EnumEquatable {
  static func ~= (lhs: Loading<T>, rhs: Loading<T>) -> Bool {
    switch (lhs, rhs) {
    case (_, .notLoaded),
         (.loading, .loading),
         (.loaded, .loaded),
         (.error, .error):
      return true
    default:
      return false
    }
  }
}
