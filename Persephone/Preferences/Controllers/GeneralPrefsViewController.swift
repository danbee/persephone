//
//  PreferencesViewController.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/14.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import ReSwift

class GeneralPrefsViewController: NSViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    if let mpdHost = AppDelegate.store.state.preferencesState.mpdServer.host {
      mpdHostField.stringValue = mpdHost
    }

    if let mpdPort = AppDelegate.store.state.preferencesState.mpdServer.port {
      print(mpdPort)
      mpdPortField.stringValue = "\(mpdPort)"
    }

    preferredContentSize = NSMakeSize(view.frame.size.width, view.frame.size.height)
  }

  override func viewDidAppear() {
    super.viewDidAppear()

    guard let title = title
      else { return }
    self.parent?.view.window?.title = title
  }

  @IBAction func updateMpdHost(_ sender: NSTextField) {
    AppDelegate.store.dispatch(UpdateServerHost(host: sender.stringValue))
  }

  @IBAction func updateMpdPort(_ sender: NSTextField) {
    AppDelegate.store.dispatch(UpdateServerPort(port: sender.integerValue))
  }

  @IBOutlet var mpdHostField: NSTextField!
  @IBOutlet var mpdPortField: NSTextField!
}
