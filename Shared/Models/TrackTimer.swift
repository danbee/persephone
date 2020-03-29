//
//  TrackTimer.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/4/19.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

class TrackTimer {
  var timer: Timer?
  var startTime: CFTimeInterval = CFTimeInterval(machTimeS())
  var startElapsed: Double = 0

  func start(elapsedTimeMs: UInt?) {
    guard let elapsedTimeMs = elapsedTimeMs else { return }

    startTime = CFTimeInterval(machTimeS())
    startElapsed = Double(elapsedTimeMs) / 1000

    DispatchQueue.main.async {
      self.timer?.invalidate()

      self.timer = Timer.scheduledTimer(
        withTimeInterval: 0.25,
        repeats: true
      ) { _ in
        let currentTime = CFTimeInterval(machTimeS())

        let timeDiff = currentTime - self.startTime
        let newElapsedTimeMs = UInt((self.startElapsed + timeDiff) * 1000)

        App.store.dispatch(
          UpdateElapsedTimeAction(elapsedTimeMs: newElapsedTimeMs)
        )
      }
    }
  }

  func stop(elapsedTimeMs: UInt?) {
    guard let elapsedTimeMs = elapsedTimeMs else { return }

    DispatchQueue.main.async {
      self.timer?.invalidate()

      App.store.dispatch(
        UpdateElapsedTimeAction(elapsedTimeMs: elapsedTimeMs)
      )
    }
  }
}
