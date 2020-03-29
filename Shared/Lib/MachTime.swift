//
//  MachTime.swift
//  Persephone
//
//  Created by Daniel Barber on 2020-3-19.
//  Copyright © 2020 Dan Barber. All rights reserved.
//

func machTime() -> UInt64 {
  var info = mach_timebase_info()
  mach_timebase_info(&info)
  
  return mach_absolute_time() * UInt64(info.numer) / UInt64(info.denom)
}

func machTimeS() -> Double {
  return Double(machTime()) / 1_000_000_000
}
