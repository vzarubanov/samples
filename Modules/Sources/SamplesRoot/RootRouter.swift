//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 17/08/2023.
//

import Foundation
import UIKit

public protocol RootRouterProtocol {
  func makeViewController() -> UIViewController
}

final class RootRouter: RootRouterProtocol {
  private let builder: RootBuilder
  
  internal init(builder: RootBuilder) {
    self.builder = builder
  }
    
  public func makeViewController() -> UIViewController {
    let presenter = builder.buildPresenter()
    let view = RootViewController(presenter: presenter)
    presenter.view = view
    
    return view
  }
}
