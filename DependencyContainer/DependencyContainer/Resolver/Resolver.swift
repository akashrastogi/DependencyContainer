//
//  Resolver.swift
//  DependencyContainer
//
//  Created by Akash Rastogi on 26/2/21.
//

import Foundation

public protocol Resolver {
  /// Resolves to an instance of type `Service` if instance/factory has already been registered.
  func resolve<Service>(_ serviceType: Service.Type, name: String?) -> Service
}

extension Resolver {
  func resolve<Service>(_ serviceType: Service.Type) -> Service {
    return resolve(serviceType, name: nil)
  }
}
