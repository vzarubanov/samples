//
//  ImageProcessingRouter.swift
//  
//
//  Created by Vasil Zarubanau on 20/08/2023.
//

import Foundation
import UIKit
import SamplesUI

@MainActor
public protocol ImageProcessingRouterProtocol {
	func makeViewController() -> UIViewController
	func pickImage(on viewController: UIViewController) async -> UIImage?
}

public struct ImageProcessingRouter: ImageProcessingRouterProtocol {
	public init() {}

	public func makeViewController() -> UIViewController {
		let filterService = CIFiltersService()
		let interactor = ImageProcessingInteractor(filterService: filterService)
		let presenter = ImageProcessingPresenter(router: self, interactor: interactor)
		let view = ImageProcessingViewController(presenter: presenter)
		presenter.view = view
		view.title = "Image Processing"
		return view
	}

	public func pickImage(on viewController: UIViewController) async -> UIImage? {
		let fileManager = FileManager.default
		guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
		let picker = SingleMediaPicker(fileManager: fileManager, destinationDirectory: cachesDirectory)
		guard let imageModel = await picker.pickImage(on: viewController, animated: true) else { return nil }
		return UIImage(contentsOfFile: imageModel.url.path())
	}
}
