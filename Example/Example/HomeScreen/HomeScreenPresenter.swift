//
//  HomeScreenPresenter.swift
//  HomeScreenPresenter
//
//  Created by Akash Rastogi on 27/2/21.
//

import Foundation

protocol HomeScreenPresenting: AnyObject {
  func onViewDidLoad()
}

final class HomeScreenPresenter: HomeScreenPresenting {
  weak var view: HomeScreenView?
  private let interactor: HomeScreenInteracting
  private let router: HomeScreenRouting
  private let tracker: EventTracking

  init(
    interactor: HomeScreenInteracting,
    router: HomeScreenRouting,
    tracker: EventTracking
  ) {
    self.interactor = interactor
    self.router = router
    self.tracker = tracker
  }

  func onViewDidLoad() {
    tracker.trackEvent(name: "HomeScreenLoaded")
  }
}
