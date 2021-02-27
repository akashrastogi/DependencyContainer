//
//  AppDelegate.swift
//  Example
//
//  Created by Akash Rastogi on 27/2/21.
//

import UIKit
import DependencyContainer

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let container = Container()
    container.register(LoaderProviding.self) { _ -> LoaderProviding in
      LoaderProvider()
    }
    
    container.register(EventTracking.self) { _ -> EventTracking in
      EventTracker()
    }
    
    let homeViewController = HomeScreenModuleBuilder(container).buildModule()
    let navigationController = UINavigationController(rootViewController: homeViewController)
    navigationController.navigationBar.tintColor = UIColor.darkText
    let screen = UIScreen.main
    window = UIWindow(frame: screen.bounds)
    window?.rootViewController = navigationController
    window?.backgroundColor = UIColor.white
    window?.makeKeyAndVisible()
    return true
  }
}
