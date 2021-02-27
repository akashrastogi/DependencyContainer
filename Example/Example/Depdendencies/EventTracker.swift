//
//  EventTracker.swift
//  Example
//
//  Created by Akash Rastogi on 27/2/21.
//

import Foundation

struct EventTracker: EventTracking {
  func trackEvent(name: String) {
    print("event received- \(name)")
  }
}
