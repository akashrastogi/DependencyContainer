//
//  Factory.swift
//  DependencyContainer
//
//  Created by Akash Rastogi on 26/2/21.
//

import Foundation

/// Define Factory to generate instances of the generic type `Service`
public typealias Factory<Service> = (Resolver) -> Service
