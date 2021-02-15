//
//  NowPlayingTabBarController.swift
//  Persephone
//
//  Created by Dan Barber on 2020-6-12.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit

class NowPlayingTabBarController: UITabBarController {
  let nowPlayingViewController = NowPlayingBarViewController()

  override func viewDidLoad() {
    super.viewDidLoad()

    let subview = nowPlayingViewController.view!
    view.addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      subview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      subview.topAnchor.constraint(equalTo: tabBar.topAnchor),
      subview.heightAnchor.constraint(equalToConstant: NowPlayingTabBar.barHeight),
    ])

    additionalSafeAreaInsets.bottom = NowPlayingTabBar.barHeight
  }
}
