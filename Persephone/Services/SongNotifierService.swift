//
//  SongNotifierService.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/14.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

struct SongNotifierService {
  let song: Song
  let image: NSImage?

  func deliver() {
    let notification = NSUserNotification()
    notification.title = song.title
    notification.subtitle = "\(song.artist) — \(song.album.title)"
    notification.contentImage = image

    NSUserNotificationCenter.default.deliver(notification)
  }
}
