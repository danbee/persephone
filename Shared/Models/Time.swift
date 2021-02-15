//
//  Time.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

struct Time {
  let timeInSeconds: Int

  var formattedTime: String {
    let formatter = DateComponentsFormatter()

    if timeInSeconds >= 3600 {
      formatter.allowedUnits = [.second, .minute, .hour]
    } else {
      formatter.allowedUnits = [.second, .minute]
    }

    formatter.zeroFormattingBehavior = .pad
    formatter.unitsStyle = .positional

    return formatter.string(from: TimeInterval(timeInSeconds))!
  }
  
  var hours: Int { timeInSeconds / 3600 }
  
  var minutes: Int { timeInSeconds % 3600 / 60 }
}
