//
//  ImageProcessingPresenter.swift
//  
//
//  Created by Vasil Zarubanau on 20/08/2023.
//

import Foundation
import UIKit

@MainActor
protocol ImageProcessingPresenterProtocol {
	func requestPickImage()
	func requestConfigureFilter()
	func selectFilter(at index: Int)
}

final class ImageProcessingPresenter {
	private let router: ImageProcessingRouterInternalProtocol
	private let interactor: ImageProcessingInteractorProtocol
	weak var view: ImageProcessingViewProtocol?

	private var originalImage: UIImage?
	private var selectedFilterIndex: Int = 0

	private var filterViewModels: [FilterViewModel] = []

	init(router: ImageProcessingRouterInternalProtocol, interactor: ImageProcessingInteractorProtocol) {
		self.router = router
		self.interactor = interactor
	}
}

extension ImageProcessingPresenter: ImageProcessingPresenterProtocol {
	func requestConfigureFilter() {
		guard let view, selectedFilterIndex < filterViewModels.count else { return }
		let selectedFilterViewModel = filterViewModels[selectedFilterIndex]
		router.openFilterAttributes(for: selectedFilterViewModel.filter, in: view, with: self)
	}

	func requestPickImage() {
		Task {
			guard let viewController = view, let image = await router.pickImage(on: viewController) else { return }
			originalImage = image
			await MainActor.run {
				viewController.set(progressActive: true)
			}

			let filters = await interactor.getFilters()
			filterViewModels = await getFilterModels(from: filters, for: image)

			await MainActor.run {
				guard filterViewModels.isEmpty else {
					selectFilter(at: selectedFilterIndex)
					return
				}

				viewController.set(image: image)
				viewController.apply(filters: filterViewModels)
				viewController.set(progressActive: false)
			}
		}
	}

	@MainActor func selectFilter(at index: Int) {
		guard selectedFilterIndex < filterViewModels.count else { return }
		filterViewModels[selectedFilterIndex].isSelected = false

		guard index < filterViewModels.count else { return }
		selectedFilterIndex = index
		filterViewModels[index].isSelected = true

		view?.set(progressActive: true)

		let selectedFilterViewModel = filterViewModels[index]

		guard let view else { return }
		view.set(title: selectedFilterViewModel.title)
		view.apply(filters: filterViewModels)
		if let image = selectedFilterViewModel.thumbnail {
			view.set(image: image)
		}
		view.set(progressActive: false)
	}
}

private extension ImageProcessingPresenter {
	func getFilterModels(from filters: [Filter], for image: UIImage) async -> [FilterViewModel] {
		var viewModels = [FilterViewModel]()

		for item in filters.enumerated() {
			let filter = item.element
			let thumbnail = await interactor.apply(filter: filter, to: image)
			let viewModel = FilterViewModel(
				filter: filter,
				title: filter.name,
				thumbnail: thumbnail,
				isSelected: item.offset == selectedFilterIndex
			)
			viewModels.append(viewModel)
		}

		return viewModels
	}

	func applyFilterAttributeValue<T>(_ value: T, forAttributeInputKey inputKey: String) {
		Task {
			guard let image = originalImage, selectedFilterIndex < filterViewModels.count else { return }
			let selectedFilterViewModel = filterViewModels[selectedFilterIndex]

			guard let processedImage = await interactor.apply(filter: selectedFilterViewModel.filter, to: image, with: [inputKey: value]) else { return }
			await MainActor.run {
				view?.set(image: processedImage)
			}
		}
	}
}

extension ImageProcessingPresenter: ImageProcessingAttributesViewModelDelegate {
	func attributesViewModelDidReceive(value: CGFloat, forAttributeId key: String) {
		applyFilterAttributeValue(value, forAttributeInputKey: key)
	}

	func attributesViewModelDidReceive(value: FilterVectorAttribute.Vector, forAttributeId key: String) {
		applyFilterAttributeValue(value.ciVector, forAttributeInputKey: key)
	}
}
