//
//  AlbumItemView.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/17.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class AlbumItemView: NSView {
  var trackingArea: NSTrackingArea?

  override func updateTrackingAreas() {
    super.updateTrackingAreas()

    guard let albumImageView = imageView else { return }

    if let trackingArea = self.trackingArea {
      self.removeTrackingArea(trackingArea)
    }

    let trackingArea = NSTrackingArea(
      rect: albumImageView.frame,
      options: [.mouseEnteredAndExited, .activeAlways],
      owner: self,
      userInfo: nil
    )

    self.trackingArea = trackingArea
    addTrackingArea(trackingArea)
  }

  required init?(coder decoder: NSCoder) {
    super.init(coder: decoder)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(viewWillScroll(_:)),
      name: NSScrollView.willStartLiveScrollNotification,
      object: nil
    )
  }

  @objc func viewWillScroll(_ notification: Notification) {
    hidePlayButton()
  }

  override func resize(withOldSuperviewSize oldSize: NSSize) {
    hidePlayButton()
  }

  override func mouseEntered(with event: NSEvent) {
    showPlayButton()
  }

  override func mouseExited(with event: NSEvent) {
    hidePlayButton()
  }

  func showPlayButton() {
    playButton.isHidden = false
  }

  func hidePlayButton() {
    playButton.isHidden = true
  }

  @IBOutlet var imageView: NSImageView!
  @IBOutlet var playButton: NSButton!
}
