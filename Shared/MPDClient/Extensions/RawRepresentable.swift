//
//  RawRepresentable.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/08.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension RawRepresentable where Self: Equatable {
  func isOneOf<Options: Sequence>(_ options: Options) -> Bool where Options.Element == Self {
    return options.contains(self)
  }
}
