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
    
    if App.store.state.preferencesState.fetchArtworkFromCustomURL {
      customArtworkURLButton.state = .on
    } else {
      customArtworkURLButton.state = .off
    }
    
    if let urlString = App.store.state.preferencesState.customArtworkURL?.absoluteString {
        customArtworkURLTextField.stringValue = urlString
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
    
  @IBAction func updateCustomArtworkURLToggle(_ sender: NSButton) {
    App.store.dispatch(
        UpdateCustomArtworkURLToggle(useCustomArtworkURL: sender.state == .on)
    )
  }
    
  @IBAction func updateCustomArtworkURL(_ sender: NSTextField) {
    App.store.dispatch(
        UpdateCustomArtworkURL(customArtworkURL: sender.stringValue)
    )
  }

  @IBAction func clearAlbumArtCache(_ sender: NSButton) {
    KingfisherManager.shared.cache.clearDiskCache()
    KingfisherManager.shared.cache.clearMemoryCache()
  }
  
  @IBOutlet var fetchMissingArtworkFromInternet: NSButton!
  @IBOutlet var customArtworkURLTextField: NSTextField!
  @IBOutlet var customArtworkURLButton: NSButton!
}
