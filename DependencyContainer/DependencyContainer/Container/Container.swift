//
//  Container.swift
//  DependencyContainer
//
//  Created by Akash Rastogi on 26/2/21.
//

import Foundation

/// Stores the configuration on how to create instances of the registered types
public final class Container {
  private var dependencies: ThreadSafeMap<String, DependencyReference>

  public init() {
    self.dependencies = ThreadSafeMap<String, DependencyReference>()
  }

  /// Initializes a new container with existing dependencies
  private init(dependencies: ThreadSafeMap<String, DependencyReference>) {
    self.dependencies = dependencies
  }

  /// Get name of service if not received
  private func typeName(some: Any) -> String {
    "\(type(of: some))"
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
    switch scope {
    case .transient:
      dependencyReference.transientDependency = factory
    case .container:
      let resolver = Container(dependencies: dependencies)
      dependencyReference.containerDependency = factory(resolver)
    case .weak:
      let resolver = Container(dependencies: dependencies)
      dependencyReference.weakDependency = factory(resolver) as AnyObject
    }
    dependencies[key] = dependencyReference
  }

  /// Remove instance/factory from the container by type or name
  public func remove<Service>(
    _ serviceType: Service.Type,
    name: String? = nil
  ) {
    let key = name ?? typeName(some: Service.self)
    dependencies.removeValue(forKey: key)
  }

  /// Remove all the instances and factories from the container
  public func removeAll() {
    dependencies.removeAll()
  }
}

extension Container: Resolver {
  /// Resolves to an instance of type `Service` if instance/factory has already been registered.
  public func resolve<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service? {
    let key = name ?? typeName(some: Service.self)
    guard let dependencyReference = dependencies[key] else {
      return nil
    }
    var service: Service?
    switch dependencyReference.scope {
    case .transient:
      let factory = dependencyReference.transientDependency as? Factory<Service>
      let resolver = Container(dependencies: dependencies)
      service = factory?(resolver)
    case .container:
      service = dependencyReference.containerDependency as? Service
    case .weak:
      service = dependencyReference.weakDependency as? Service
    }
    return service
  }
}

private extension Container {
  class ThreadSafeMap<Key: Hashable, Value> {
    private var dictionary: [Key: Value]
    init() {
      self.dictionary = [Key: Value]()
    }

    private let queue = DispatchQueue(
      label: "Container.queue",
      attributes: .concurrent
    )

    subscript(key: Key) -> Value? {
      get {
        queue.sync { [weak self] in
          self?.dictionary[key]
        }
      }
      set(newValue) {
        queue.async(flags: .barrier) { [weak self] in
          self?.dictionary[key] = newValue
        }
      }
    }

    func removeAll() {
      queue.async(flags: .barrier) { [weak self] in
        self?.dictionary.removeAll()
      }
    }

    func removeValue(forKey key: Key) {
      queue.async(flags: .barrier) { [weak self] in
        self?.dictionary.removeValue(forKey: key)
      }
    }
  }
}
