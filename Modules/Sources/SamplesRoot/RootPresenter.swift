//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 17/08/2023.
//

import Foundation
import UIKit

public protocol RootPresenterProtocol {
  var selectedControllerIndex: Int { get }
  func controllers() -> [UIViewController]
  func selectController(at index: Int)
}

final class RootPresenter: RootPresenterProtocol {
  struct Dependencies {
    let makeSampleImageController: () -> UIViewController
    let makeSampleVideoController: () -> UIViewController
  }

  private let dependencies: Dependencies
  init(_ dependencies: Dependencies) {
    self.dependencies = dependencies
  }

  weak var view: RootViewController?

  private(set) var selectedControllerIndex = 0

  func controllers() -> [UIViewController] {
    let sampleImageController = dependencies.makeSampleImageController()
    let sampleVideoController = dependencies.makeSampleVideoController()

    return [sampleImageController, sampleVideoController]
  }

  func selectController(at index: Int) {

  }
}
