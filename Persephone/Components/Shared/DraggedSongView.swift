//
//  DraggedSong.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/18.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class DraggedSongView: NSViewController {
  @IBOutlet var titleLabel: NSTextField!
  @IBOutlet var artistLabel: NSTextField!

  private let songTitle: String
  private let songArtist: String

  init(title: String, artist: String) {
    songTitle = title
    songArtist = artist
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.stringValue = songTitle
    artistLabel.stringValue = songArtist
  }
}
