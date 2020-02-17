  //
//  VolumeControlView.swift
//  Persephone
//
//  Created by Daniel Barber on 2/16/20.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

import AppKit
import ReSwift

class VolumeControlView: NSViewController {
  static let shared = VolumeControlView()
  static let popover = NSPopover()
  
  var currentVolume: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    
    App.store.subscribe(self) {
      $0.select { $0.playerState }
    }
  }
  
  @IBAction func volumeSliderAction(_ sender: NSSlider) {
    let newVolume = sender.integerValue

    if newVolume != currentVolume {
      App.mpdClient.setVolume(to: newVolume)
      currentVolume = newVolume
    }
  }
  
  @IBOutlet var volumeSlider: NSSlider!
}
  
extension VolumeControlView: StoreSubscriber {
  typealias StoreSubscriberStateType = PlayerState
  
  func newState(state: StoreSubscriberStateType) {
    volumeSlider.integerValue = state.volume
    currentVolume = state.volume
  }
}
