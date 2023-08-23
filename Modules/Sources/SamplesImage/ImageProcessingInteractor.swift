//
//  ImageProcessingInteractor.swift
//  
//
//  Created by Vasil Zarubanau on 21/08/2023.
//

import Foundation
import UIKit

protocol ImageProcessingInteractorProtocol {
	func getFilters() async -> [Filter]
	func apply(filter: Filter, to image: UIImage, with options: [String: Any]) async -> UIImage?
}

extension ImageProcessingInteractorProtocol {
	func apply(filter: Filter, to image: UIImage) async -> UIImage? {
		await apply(filter: filter, to: image, with: [:])
	}
}

struct ImageProcessingInteractor: ImageProcessingInteractorProtocol {
	let filterService: FiltersServiceProtocol

	func getFilters() async -> [Filter] {
		let ids = CIFiltersService.CIFilterID.allCases.map { $0.rawValue }
		return await filterService.getFilters(ids: ids)
	}

	func apply(filter: Filter, to image: UIImage, with options: [String: Any]) async -> UIImage? {
		guard let cgImage = image.cgImage else { return nil }
		do {
			guard let cgImage = try await filterService.apply(filter: filter, to: cgImage, with: options) else {
				return nil
			}
			return UIImage(cgImage: cgImage)
		} catch {
			debugPrint(error)
			return nil
		}
	}
}
