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
	func apply(filter: Filter, to image: UIImage) async -> UIImage?
}

struct ImageProcessingInteractor: ImageProcessingInteractorProtocol {
	let filterService: FiltersServiceProtocol

	func getFilters() async -> [Filter] {
		let ids = CIFiltersService.CIFilterID.allCases.map { $0.rawValue }
		return filterService.getFilters(ids: ids)
	}

	func apply(filter: Filter, to image: UIImage) async -> UIImage? {
		guard let cgImage = image.cgImage else { return nil }
		do {
			guard let cgImage = try await filterService.apply(filter: filter, to: cgImage, with: [:]) else {
				return nil
			}
			return UIImage(cgImage: cgImage)
		} catch {
			debugPrint(error)
			return nil
		}
	}
}
