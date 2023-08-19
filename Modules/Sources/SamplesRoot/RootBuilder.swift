//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 17/08/2023.
//

import Foundation

struct RootBuilder {
  private let dependencies: RootModule.Injection
  
  init(_ dependencies: RootModule.Injection) {
    self.dependencies = dependencies
  }
  
  func buildPresenter() -> RootPresenter {
    RootPresenter()
  }
  
  func buildRouter() -> RootRouter {
    RootRouter(builder: self)
  }
}
