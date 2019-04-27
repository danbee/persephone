//
//  TrackTimer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa

class TrackTimer: NSObject {
  var timer: Timer?
  var startTime: CFTimeInterval = CACurrentMediaTime()
  var startElapsed: Double = 0

  func start(elapsedTimeMs: UInt?) {
    guard let elapsedTimeMs = elapsedTimeMs else { return }

    timer?.invalidate()

    startTime = CACurrentMediaTime()
    startElapsed = Double(elapsedTimeMs) / 1000

    DispatchQueue.main.async {
      self.timer = Timer.scheduledTimer(
        withTimeInterval: 0.25,
        repeats: true
      ) { _ in
        let currentTime = CACurrentMediaTime()

        let timeDiff = currentTime - self.startTime
        let newElapsedTimeMs = UInt((self.startElapsed + timeDiff) * 1000)

        AppDelegate.store.dispatch(
          UpdateElapsedTimeAction(elapsedTimeMs: newElapsedTimeMs)
        )
      }
    }
  }

  func stop(elapsedTimeMs: UInt?) {
    guard let elapsedTimeMs = elapsedTimeMs else { return }

    timer?.invalidate()

    DispatchQueue.main.async {
      AppDelegate.store.dispatch(
        UpdateElapsedTimeAction(elapsedTimeMs: elapsedTimeMs)
      )
    }
  }
}
