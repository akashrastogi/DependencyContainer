//
//  HomeScreenModuleBuilder.swift
//  HomeScreenModuleBuilder
//
//  Created by Akash Rastogi on 27/2/21.
//

import UIKit
import DependencyContainer

protocol HomeScreenModuleBuilding {
  func buildModule() -> UIViewController
}

struct HomeScreenModuleBuilder: HomeScreenModuleBuilding {

  private let container: Container
  init(_ container: Container) {
    self.container = container
  }
  
  func buildModule() -> UIViewController {
    let interactor = HomeScreenInteractor()
    let router = HomeScreenRouter()
    let presenter = HomeScreenPresenter(
      interactor: interactor,
      router: router,
      tracker: container.resolve(EventTracking.self)
    )
    let view = HomeScreenViewController(
      presenter: presenter,
      loaderProvider:container.resolve(LoaderProviding.self)
    )
    presenter.view = view

    interactor.presenter = presenter
    router.viewController = view

    return view
  }
}
