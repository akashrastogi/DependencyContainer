//
//  HomeScreenInteractor.swift
//  HomeScreenInteractor
//
//  Created by Akash Rastogi on 27/2/21.
//

import Foundation

protocol HomeScreenInteracting: AnyObject {
  
  var presenter: HomeScreenPresenting?  { get set }
}

final class HomeScreenInteractor: HomeScreenInteracting {
  
  weak var presenter: HomeScreenPresenting?
}
