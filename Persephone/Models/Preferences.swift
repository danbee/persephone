//
//  Preferences.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

struct Preferences {
  var mpdHost: String? {
    get {
      return UserDefaults.standard.string(forKey: "mpdHost")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "mpdHost")
    }
  }

  var mpdPort: Int? {
    get {
      return UserDefaults.standard.value(forKey: "mpdPort") as? Int
    }
    set {
      if (newValue.map { $0 > 0 } ?? false) {
        UserDefaults.standard.set(newValue, forKey: "mpdPort")
      } else {
        UserDefaults.standard.removeObject(forKey: "mpdPort")
      }
    }
  }

  var mpdHostOrDefault: String {
    return mpdHost ?? "127.0.0.1"
  }

  var mpdPortOrDefault: Int {
    return mpdPort ?? 6600
  }
}
