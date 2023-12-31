//
//  CIFiltersService.swift
//  
//
//  Created by Vasil Zarubanau on 21/08/2023.
//

import Foundation
import CoreImage

final actor CIFiltersService: FiltersServiceProtocol {
	private let context = CIContext()
	private var filtersCache: [Filter.ID: CIFilter] = [:]

	func getFilters(ids: [Filter.ID]) async -> [Filter] {
		ids.compactMap { id -> Filter? in
			guard let filter = CIFilter(name: id) else { return nil }
			return Filter(CIAttributesDictionary: filter.attributes)
		}
	}

	func apply(filter: Filter, to image: CGImage, with options: [String: Any]) async throws -> CGImage? {

		let ciFilter: CIFilter?
		if let cachedFilter = filtersCache[filter.id] {
			ciFilter = cachedFilter
		} else {
			ciFilter = CIFilter(name: filter.id)
			filtersCache[filter.id] = ciFilter
		}

		return try await withCheckedThrowingContinuation { continuation in

			guard let currentFilter = ciFilter else {
				continuation.resume(throwing: FilterError.filterNotFound)
				return
			}
			let ciImage = CIImage(cgImage: image)
			currentFilter.setValue(ciImage, forKey: kCIInputImageKey)

			let inputKeys = currentFilter.inputKeys
			for (key, value) in options where inputKeys.contains(key) {
				currentFilter.setValue(value, forKey: key)
			}

			guard let outputImage = currentFilter.outputImage else {
				continuation.resume(throwing: FilterError.noOutputImage)
				return
			}

			let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
			continuation.resume(returning: cgImage)
		}
	}
}

// MARK: - Models
extension CIFiltersService {
	enum CIFilterID: String, CaseIterable {
		case sepiaTone = "CISepiaTone"
		case bumpDistortion = "CIBumpDistortion"
		case gaussianBlur = "CIGaussianBlur"
		case pixellate = "CIPixellate"
	}

	enum FilterError: Error {
		case filterNotFound
		case noOutputImage
	}
}
