//
//  LoaderProvider.swift
//  Example
//
//  Created by Akash Rastogi on 27/2/21.
//

import UIKit

struct LoaderProvider: LoaderProviding {
  func showLoadingView(on view: UIView) {
    print("adding loader")
  }

  func hideLoadingView(on view: UIView) {
    print("removing loader")
  }
}
