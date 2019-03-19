//
//  Preferences.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/15.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

struct Preferences {
  let mpdHostDefault = "127.0.0.1"
  let mpdPortDefault = 6600
  let mpdLibraryDirDefault = "~/Music"

  let preferences = UserDefaults.standard

  var mpdHost: String? {
    get {
      return preferences.string(forKey: "mpdHost")
    }
    set {
      preferences.set(newValue, forKey: "mpdHost")
    }
  }

  var mpdHostOrDefault: String {
    return mpdHost ?? mpdHostDefault
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

  var mpdPortOrDefault: Int {
    return mpdPort ?? mpdPortDefault
  }

  var mpdLibraryDir: String? {
    get {
      return preferences.string(forKey: "mpdLibraryDir")
    }
    set {
      preferences.set(newValue, forKey: "mpdLibraryDir")
    }
  }

  var mpdLibraryDirOrDefault: String {
    return mpdLibraryDir ?? mpdLibraryDirDefault
  }

  var expandedMpdLibraryDir: String {
    return NSString(string: mpdLibraryDirOrDefault).expandingTildeInPath
  }

  var fetchMissingArtworkFromInternet: Bool {
    get {
      return preferences.bool(forKey: "fetchMissingArtworkFromInternet")
    }
    set {
      preferences.set(newValue, forKey: "fetchMissingArtworkFromInternet")
    }
  }

  func addObserver(_ observer: NSObject, forKeyPath keyPath: String) {
    preferences.addObserver(observer, forKeyPath: keyPath, options: .new, context: nil)
  }
}
