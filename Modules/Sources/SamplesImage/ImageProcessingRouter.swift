//
//  ImageProcessingRouter.swift
//  
//
//  Created by Vasil Zarubanau on 20/08/2023.
//

import Foundation
import UIKit
import SamplesUI
import SwiftUI

@MainActor
public protocol ImageProcessingRouterProtocol {
	func makeViewController() -> UIViewController
}

@MainActor
protocol ImageProcessingRouterInternalProtocol: ImageProcessingRouterProtocol {
	func pickImage(on viewController: UIViewController) async -> UIImage?
	func openFilterAttributes(for filter: Filter, in viewController: UIViewController, with delegate: ImageProcessingAttributesViewModelDelegate?)
}

public struct ImageProcessingRouter: ImageProcessingRouterInternalProtocol {
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

	func pickImage(on viewController: UIViewController) async -> UIImage? {
		let fileManager = FileManager.default
		guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
		let picker = SingleMediaPicker(fileManager: fileManager, destinationDirectory: cachesDirectory)
		guard let imageModel = await picker.pickImage(on: viewController, animated: true) else { return nil }
		return UIImage(contentsOfFile: imageModel.url.path())
	}

	func openFilterAttributes(for filter: Filter, in viewController: UIViewController, with delegate: ImageProcessingAttributesViewModelDelegate?) {
		let viewModel = ImageProcessingAttributesViewModel(filter: filter, delegate: delegate)
		let view = ImageProcessingAttributesView(viewModel: viewModel)
		let hostinhViewController = UIHostingController(rootView: view)
		hostinhViewController.modalPresentationStyle = .pageSheet
		hostinhViewController.sheetPresentationController?.detents = [.medium(), .large()]

		viewController.present(hostinhViewController, animated: true)
	}
}
