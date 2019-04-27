//
//  EnumEquatable.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/27.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

protocol EnumEquatable {
  static func ~=(lhs: Self, rhs: Self) -> Bool
}
