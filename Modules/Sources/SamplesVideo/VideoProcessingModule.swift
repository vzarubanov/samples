//
//  VideoProcessingModule.swift
//  
//
//  Created by Vasil Zarubanau on 19/08/2023.
//

import UIKit

public protocol VideoProcessingModuleProtocol {
  func makeViewController() -> UIViewController
}

public struct VideoProcessingModule: VideoProcessingModuleProtocol {
  public struct Injection {
    public init() {}
  }

	public init(_ dependencies: Injection) {
  }

  public func makeViewController() -> UIViewController {
		let viewModel = VideoProcessingViewModel()
		let view = VideoProcessingViewController(viewModel: viewModel)
		view.title = "Video processing"
		return view
  }
}
