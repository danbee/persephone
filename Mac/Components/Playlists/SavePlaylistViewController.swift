//
//  SavePlaylistViewController.swift
//  Persephone
//
//  Created by Dan Barber on 2020-4-11.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import AppKit

class SavePlaylistViewController: NSViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func saveButtonAction(_ sender: Any) {
    App.mpdClient.saveQueueToPlaylist(name: playlistName.stringValue)
    self.dismiss(sender)
  }

  @IBAction func cancelButtonAction(_ sender: Any) {
    self.dismiss(sender)
  }

  @IBOutlet var playlistName: NSTextFieldCell!
}
