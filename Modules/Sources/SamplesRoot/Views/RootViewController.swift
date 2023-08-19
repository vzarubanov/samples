//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 17/08/2023.
//

import Foundation
import UIKit
import SamplesUI

class RootViewController: UIViewController {
  private var presenter: RootPresenterProtocol!

  private let tabsController = UITabBarController(nibName: nil, bundle: nil)

	init(presenter: RootPresenterProtocol) {
    super.init(nibName: nil, bundle: nil)
    self.presenter = presenter

    self.configureUI()
    self.configureTabsController()
  }

	@available(*, unavailable)
	required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Configure UI
private extension RootViewController {
  func configureUI() {
    view.backgroundColor = .white

    tabsController.delegate = self
    addChild(viewController: tabsController, forwardsAppearanceCallbacks: false)
  }

  func configureTabsController() {
    tabsController.viewControllers = presenter.controllers()
    tabsController.selectedIndex = presenter.selectedControllerIndex
  }
}

extension RootViewController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return }
    presenter.selectController(at: index)
  }
}
