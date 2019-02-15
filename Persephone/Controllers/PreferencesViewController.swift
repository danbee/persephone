//
//  PreferencesViewController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/14.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
  var preferences = Preferences()

  override func viewDidLoad() {
    super.viewDidLoad()

    if let mpdHost = preferences.mpdHost {
      mpdHostField.stringValue = mpdHost
    }

    if let mpdPort = preferences.mpdPort {
      mpdPortField.stringValue = "\(mpdPort)"
    }
  }

  @IBAction func updateMpdHost(_ sender: NSTextField) {
    preferences.mpdHost = sender.stringValue
  }

  @IBAction func updateMpdPort(_ sender: NSTextField) {
    preferences.mpdPort = sender.integerValue
  }

  @IBOutlet var mpdHostField: NSTextField!
  @IBOutlet var mpdPortField: NSTextField!
}
