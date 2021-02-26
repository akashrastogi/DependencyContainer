//
//  DependencyReference.swift
//  DependencyContainer
//
//  Created by Akash Rastogi on 26/2/21.
//

import Foundation

/// Model to hold references of instance and factory
struct DependencyReference {
  weak var weakDependency: AnyObject?
  var transientDependency: Any?
  var containerDependency: Any?
  let scope: ObjectScope

  init(scope: ObjectScope) {
    self.scope = scope
  }
}
