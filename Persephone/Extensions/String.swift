//
//  String.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/3/01.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

extension String {
  func sha1() -> String {
    let data = self.data(using: String.Encoding.utf8)!
    var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))

    data.withUnsafeBytes {
      _ = CC_SHA1($0, CC_LONG(data.count), &digest)
    }

    let hexBytes = digest.map { String(format: "%02hhx", $0) }

    return hexBytes.joined()
  }
}
