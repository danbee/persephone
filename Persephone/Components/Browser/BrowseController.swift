//
//  BrowseController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/9/20.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import ReSwift

class BrowseController: NSViewController {
  @IBOutlet var browseTabView: NSTabView!

  override func viewDidLoad() {
    super.viewDidLoad()

    App.store.subscribe(self) {
      $0.select { $0.uiState }
    }
  }
}

extension BrowseController: StoreSubscriber {
  typealias BrowseSubscriberStateType = UIState

  func newState(state: BrowseSubscriberStateType) {
    browseTabView.selectTabViewItem(at: state.browseViewState.rawValue)
  }
}
