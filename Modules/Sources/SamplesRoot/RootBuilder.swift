//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 17/08/2023.
//

import Foundation
import UIKit

struct RootBuilder {
  private let dependencies: RootModule.Injection

	init(_ dependencies: RootModule.Injection) {
    self.dependencies = dependencies
  }

	@MainActor
	func buildPresenter() -> RootPresenter {
    RootPresenter(.init(
			makeSampleImageController: {
				let viewController = dependencies.imageModule.router.makeViewController()
				let navigationController = UINavigationController(rootViewController: viewController)
				return navigationController
			},
			makeSampleVideoController: dependencies.videoModule.makeViewController
    ))
  }

	@MainActor
	func makeViewController() -> UIViewController {
		let presenter = buildPresenter()
		let view = RootViewController(presenter: presenter)
		presenter.view = view

		return view
	}
}
