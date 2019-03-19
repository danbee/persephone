//
//  AlbumArtPrefsController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/23.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumArtPrefsController: NSViewController {
  var preferences = Preferences()

  override func viewDidLoad() {
    super.viewDidLoad()

    if let mpdLibraryDir = preferences.mpdLibraryDir {
      mpdLibraryDirField.stringValue = mpdLibraryDir
    }

    if preferences.fetchMissingArtworkFromInternet {
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
    preferences.mpdLibraryDir = sender.stringValue
  }

  @IBOutlet var mpdLibraryDirField: NSTextField!

  @IBAction func updateFetchMissingArtworkFromInternet(_ sender: NSButton) {
    if sender.state == .on {
      preferences.fetchMissingArtworkFromInternet = true
    } else {
      preferences.fetchMissingArtworkFromInternet = false
    }
  }

  @IBOutlet var fetchMissingArtworkFromInternet: NSButton!
}
