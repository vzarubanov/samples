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
	func selectFilter(at index: Int)
}

final class ImageProcessingPresenter: ImageProcessingPresenterProtocol {
	private let router: ImageProcessingRouterProtocol
	private let interactor: ImageProcessingInteractorProtocol
	weak var view: ImageProcessingViewProtocol?

	private var originalImage: UIImage?
	private var selectedFilterIndex: Int = 0

	private var filterViewModels: [FilterViewModel] = []

	init(router: ImageProcessingRouterProtocol, interactor: ImageProcessingInteractorProtocol) {
		self.router = router
		self.interactor = interactor
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

			guard filterViewModels.isEmpty else {
				selectFilter(at: selectedFilterIndex)
				return
			}

			await MainActor.run {
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
		let selectedFilterAttributesViewModel = getFilterAttributesViewModel(from: selectedFilterViewModel.filter)

		guard let view else { return }
		view.set(title: selectedFilterViewModel.title)
		view.apply(filters: filterViewModels)
		view.apply(attributes: selectedFilterAttributesViewModel)
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

	func getFilterAttributesViewModel(from filter: Filter) -> FilterAttributesViewModel {
		return FilterAttributesViewModel(
			title: "Attributes:",
			sliderAttributes: filter.attributes.numberAttributes.map {
				return .init(
					title: $0.name,
					description: $0.description,
					sliderRange: ClosedRange(uncheckedBounds: ($0.minValue, $0.maxValue)),
					sliderValue: $0.defaultValue
				)
			},
			vectorAttributes: filter.attributes.vectorAttributes.map {
				return .init(
					title: $0.name,
					description: $0.description,
					value: $0.defaultValue
				)
			}
		)
	}
}
