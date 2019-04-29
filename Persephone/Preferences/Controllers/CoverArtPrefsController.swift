//
//  CoverArtPrefsController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/23.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import AppKit

class CoverArtPrefsController: NSViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    if let mpdLibraryDir = AppDelegate.store.state.preferencesState.mpdLibraryDir {
      mpdLibraryDirField.stringValue = mpdLibraryDir
    }

    if AppDelegate.store.state.preferencesState.fetchMissingArtworkFromInternet {
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

  @IBAction func updateMpdLibraryDir(_ sender: NSTextField) {
    AppDelegate.store.dispatch(UpdateMPDLibraryDir(mpdLibraryDir: sender.stringValue))
  }

  @IBOutlet var mpdLibraryDirField: NSTextField!

  @IBAction func updateFetchMissingArtworkFromInternet(_ sender: NSButton) {
    AppDelegate.store.dispatch(
      UpdateFetchMissingArtworkFromInternet(
        fetchMissingArtworkFromInternet: sender.state == .on
      )
    )
  }

  @IBOutlet var fetchMissingArtworkFromInternet: NSButton!
}
