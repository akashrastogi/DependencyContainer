//
//  HomeScreenViewController.swift
//  HomeScreenViewController
//
//  Created by Akash Rastogi on 27/2/21.
//

import UIKit

protocol HomeScreenView: AnyObject {
}

final class HomeScreenViewController: UIViewController, HomeScreenView {
  
  private let presenter: HomeScreenPresenting
  private let loaderProvider: LoaderProviding
  
  init(
    presenter: HomeScreenPresenting,
    loaderProvider: LoaderProviding
  ) {
    self.presenter = presenter
    self.loaderProvider = loaderProvider
    super.init(
      nibName: String(describing: type(of: self)),
      bundle: Bundle(for: type(of: self))
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.onViewDidLoad()
    loaderProvider.showLoadingView(on: view)
    loaderProvider.hideLoadingView(on: view)
  }
}
