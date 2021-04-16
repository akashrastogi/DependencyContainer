# DependencyContainer
Light weight Dependency container in iOS purely written in Swift

## 🔩 Components

### 📦 Container

Stores the configuration on how to create instances of the registered types

### 🛠️ Resolver

Resolves the actual implementation for a type, by creating an instance of a class, using the configuration of the Container

### 🏭 Factory

A generic factory solution for creating instances of the generic type

## Object Scopes

Object Scope is a configuration option to determine how an instance provided by a DI container is shared in the system. It is represented by enum `ObjectScope` in `DependencyContainer`.
The scope can be defined at the time of dependancy registration-
```swift
container.register(EventTracking.self, scope: .container) { _ -> EventTracking in
	EventTracker()
}
```

## Built-in scopes
### Transient (the default scope)

If `ObjectScope.transient` is specified, an instance provided by a container is not shared. In other words, the container always creates a new instance from the factory everytime.

### weak

With `ObjectScope.weak`, an instance provided by a container is shared within the container as long as there are other strong references to it.

### Container

In `ObjectScope.container`, an instance provided by a container is shared within the container. It means, when you resolve the type for the first time, it is created by the container by invoking the factory closure. The same instance is returned by the container in any succeeding resolution of the type.

## 🏃‍♀️ Getting started
### 🚶‍♀️ Basic steps

1. Register all of the types using `register` method with the container.


```swift
container.register(EventTracking.self) { _ -> EventTracking in
	EventTracker()
}
```

2. Wherever you need an instance of the type, you can access it using `resolve` method.

```swift
let eventTracker: EventTracking = container.resolve(EventTracking.self)
```

## Question?

- Drop an email at [akash_rastogi@live.com](mailto:akash_rastogi@live.com)

## 📃 License

DependencyContainer is released under an MIT license. See [License.md](https://github.com/akashrastogi/DependencyContainer/blob/master/LICENSE) for more information.
