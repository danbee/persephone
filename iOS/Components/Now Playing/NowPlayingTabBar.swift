//
//  NowPlayingTabBar.swift
//  Persephone-iOS
//
//  Created by Dan Barber on 2020-6-12.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit

class NowPlayingControlBackground: UIControl {
//  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//    
//  }
//  
//  override func cancelTracking(with event: UIEvent?) {
//    
//  }
//  
//  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
//    
//    // if touch is inside your control
//    sendActions(for: .touchUpInside)
//  }
}

class NowPlayingTabBar: UITabBar {
  static let barHeight: CGFloat = 56
  
  override func awakeFromNib() {
    super.awakeFromNib()

    let bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
    NowPlayingTabBar.appearance().shadowImage = UIGraphicsImageRenderer(bounds: bounds).image { context in
      UIColor.systemRed.setFill()
      context.fill(bounds)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    for case let control as UIControl in subviews {
      control.frame.origin.y += Self.barHeight
    }
  }
}
