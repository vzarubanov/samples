//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 17/08/2023.
//

import Foundation
import UIKit

@MainActor
public protocol RootRouterProtocol {
  func makeViewController() -> UIViewController
}

struct RootRouter: RootRouterProtocol {
  private let builder: RootBuilder

	init(builder: RootBuilder) {
    self.builder = builder
  }

	public func makeViewController() -> UIViewController {
    let presenter = builder.buildPresenter()
    let view = RootViewController(presenter: presenter)
    presenter.view = view

		return view
  }
}
