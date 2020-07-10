//
//  NowPlayingTabBarController.swift
//  Persephone
//
//  Created by Dan Barber on 2020-6-12.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import UIKit

class NowPlayingTabBarController: UITabBarController {
  private var barHeight: NSLayoutConstraint!
  let nowPlayingViewController = NowPlayingViewController()

  override func viewDidLoad() {
    super.viewDidLoad()

    addChild(nowPlayingViewController)
    let subview = nowPlayingViewController.view!
    tabBar.superview?.addSubview(subview)
    tabBar.clipsToBounds = false
    subview.translatesAutoresizingMaskIntoConstraints = false
    barHeight = subview.heightAnchor.constraint(equalToConstant: 0)
    NSLayoutConstraint.activate([
      subview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      subview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      subview.topAnchor.constraint(equalTo: tabBar.topAnchor),
      barHeight,
    ])
    nowPlayingViewController.didMove(toParent: self)
    
    additionalSafeAreaInsets.bottom = NowPlayingTabBar.barHeight
  }
  
  override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
    super.preferredContentSizeDidChange(forChildContentContainer: container)
    
    barHeight.constant = container.preferredContentSize.height
  }
}
