//
//  CoverArtPrefsController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/23.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit
import Kingfisher

class CoverArtPrefsController: NSViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    if App.store.state.preferencesState.fetchMissingArtworkFromInternet {
      fetchMissingArtworkFromInternet.state = .on
    } else {
      fetchMissingArtworkFromInternet.state = .off
    }

    preferredContentSize = NSMakeSize(view.frame.size.width, view.frame.size.height)
  }

  override func viewDidAppear() {
    super.viewDidAppear()

    guard let title = title
      else { return }
    self.parent?.view.window?.title = title
  }

  @IBAction func updateFetchMissingArtworkFromInternet(_ sender: NSButton) {
    App.store.dispatch(
      UpdateFetchMissingArtworkFromInternet(
        fetchMissingArtworkFromInternet: sender.state == .on
      )
    )
  }

  @IBAction func clearAlbumArtCache(_ sender: NSButton) {
    KingfisherManager.shared.cache.clearDiskCache()
    KingfisherManager.shared.cache.clearMemoryCache()
  }
  
  @IBOutlet var fetchMissingArtworkFromInternet: NSButton!
}
