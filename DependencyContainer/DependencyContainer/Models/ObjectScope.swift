//
//  ObjectScope.swift
//  DependencyContainer
//
//  Created by Akash Rastogi on 26/2/21.
//

import Foundation

enum ObjectScope {
  case transient /// Create a new instance from factory everytime
  case weak /// Shared within the container as long as there are other strong references to it
  case container /// Same instance shared within the container
}
