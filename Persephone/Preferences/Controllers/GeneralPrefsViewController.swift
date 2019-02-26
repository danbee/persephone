//
//  PreferencesViewController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/14.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class GeneralPrefsViewController: NSViewController {
  var preferences = Preferences()

  override func viewDidLoad() {
    super.viewDidLoad()

    if let mpdHost = preferences.mpdHost {
      mpdHostField.stringValue = mpdHost
    }

    if let mpdPort = preferences.mpdPort {
      mpdPortField.stringValue = "\(mpdPort)"
    }

    preferredContentSize = NSMakeSize(view.frame.size.width, view.frame.size.height)
  }

  override func viewDidAppear() {
    super.viewDidAppear()
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
