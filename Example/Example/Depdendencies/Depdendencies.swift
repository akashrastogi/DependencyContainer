//
//  Depdency.swift
//  Example
//
//  Created by Akash Rastogi on 27/2/21.
//

import UIKit

protocol EventTracking {
  func trackEvent(name: String)
}

protocol LoaderProviding {
  func showLoadingView(on view: UIView)
  func hideLoadingView(on view: UIView)
}
