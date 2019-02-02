//
//  MPDClientDelegate.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/01.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Foundation

protocol MPDClientDelegate {
  func didUpdateState(mpdClient: MPDClient, state: MPDClient.State)
}
