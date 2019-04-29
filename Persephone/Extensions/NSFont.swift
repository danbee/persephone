//
//  NSFont.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

extension NSFont {
  static let systemFontRegular = systemFont(ofSize: 13, weight: .regular)
  static let systemFontBold = systemFont(ofSize: 13, weight: .bold)

  static let timerFont = monospacedDigitSystemFont(ofSize: 13, weight: .regular)
}
