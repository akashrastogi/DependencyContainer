//
//  Container.swift
//  DependencyContainer
//
//  Created by Akash Rastogi on 26/2/21.
//

import Foundation

/// Stores the configuration on how to create instances of the registered types
public final class Container {
  private lazy var dependencies: [String: DependencyReference] = [:]

  public init() {}

  /// Initializes a new container with existing dependencies
  private init(dependencies: [String: DependencyReference]) {
    self.dependencies = dependencies
  }

  /// Concurrent synchronization queue
  private let queue = DispatchQueue(label: "Container.queue", attributes: .concurrent)

  /// Get name of service if not received
  private func typeName(some: Any) -> String {
    queue.sync {
      "\(type(of: some))"
    }
  }

  /// Register the `instance/factory` as a object of Type `Service`.
  public func register<Service>(
    _ serviceType: Service.Type,
    scope: ObjectScope = .transient,
    name: String? = nil,
    factory: @escaping Factory<Service>
  ) {
    let key = name ?? typeName(some: Service.self)
    var dependencyReference = DependencyReference(scope: scope)

    /// Write with .barrier
    queue.async(flags: .barrier) { [weak self] in
      guard let self = self else { return }

      switch scope {
      case .transient:
        dependencyReference.transientDependency = factory
      case .container:
        let resolver = Container(dependencies: self.dependencies)
        dependencyReference.containerDependency = factory(resolver)
      case .weak:
        let resolver = Container(dependencies: self.dependencies)
        dependencyReference.weakDependency = factory(resolver) as AnyObject
      }
      self.dependencies[key] = dependencyReference
    }
  }

  /// Remove instance/factory from the container by type or name
  public func remove<Service>(
    _ serviceType: Service.Type,
    name: String? = nil
  ) {
    let key = name ?? typeName(some: Service.self)
    queue.async(flags: .barrier) { [weak self] in
      guard let self = self else { return }
      self.dependencies.removeValue(forKey: key)
    }
  }

  /// Remove all the instances and factories from the container
  public func removeAll() {
    queue.async(flags: .barrier) { [weak self] in
      guard let self = self else { return }
      self.dependencies.removeAll()
    }
  }
}

extension Container: Resolver {
  /// Resolves to an instance of type `Service` if instance/factory has already been registered.
  public func resolve<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service {
    let key = name ?? typeName(some: Service.self)
    var currentDependencies: [String: DependencyReference] = [:]

    queue.sync { // Read
      currentDependencies = dependencies
    }

    guard let dependencyReference = currentDependencies[key] else {
      fatalError("Unable to resolve \(serviceType) ")
    }
    var service: Service?
    switch dependencyReference.scope {
    case .transient:
      let factory = dependencyReference.transientDependency as? Factory<Service>
      let resolver = Container(dependencies: currentDependencies)
      service = factory?(resolver)
    case .container:
      service = dependencyReference.containerDependency as? Service
    case .weak:
      service = dependencyReference.weakDependency as? Service
    }
    guard let instance = service else {
      fatalError("Unable to resolve \(serviceType) ")
    }
    return instance
  }
}
