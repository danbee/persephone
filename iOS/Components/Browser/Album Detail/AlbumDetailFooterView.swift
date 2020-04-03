//
//  AlbumDetailFooterView.swift
//  Persephone
//
//  Created by Daniel Barber on 2020-4-2.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit

class AlbumDetailFooterView: UIView {
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    let separator = CALayer()
    separator.frame = CGRect(
      x: 20,
      y: -0.5,
      width: UIScreen.main.bounds.width - 20,
      height: 0.5
    )
    separator.backgroundColor = UIColor.separator.cgColor
    layer.addSublayer(separator)
  }
}
