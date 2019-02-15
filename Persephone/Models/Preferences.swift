//
//  Preferences.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

struct Preferences {
  let preferences = UserDefaults.standard

  var mpdHost: String? {
    get {
      return preferences.string(forKey: "mpdHost")
    }
    set {
      preferences.set(newValue, forKey: "mpdHost")
    }
  }

  var mpdPort: Int? {
    get {
      return preferences.value(forKey: "mpdPort") as? Int
    }
    set {
      if (newValue.map { $0 > 0 } ?? false) {
        preferences.set(newValue, forKey: "mpdPort")
      } else {
        preferences.removeObject(forKey: "mpdPort")
      }
    }
  }

  var mpdHostOrDefault: String {
    return mpdHost ?? "127.0.0.1"
  }

  var mpdPortOrDefault: Int {
    return mpdPort ?? 6600
  }

  func addObserver(_ observer: NSObject, forKeyPath keyPath: String) {
    preferences.addObserver(observer, forKeyPath: keyPath, options: .new, context: nil)
  }
}
