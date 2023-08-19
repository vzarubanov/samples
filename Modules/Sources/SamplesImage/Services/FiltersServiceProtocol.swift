//
//  FiltersServiceProtocol.swift
//  
//
//  Created by Vasil Zarubanau on 22/08/2023.
//

import Foundation
import UIKit

protocol FiltersServiceProtocol {
	func getFilters(ids: [Filter.ID]) -> [Filter]
	func apply(filter: Filter, to image: CGImage, with options: [String: Any]) async throws -> CGImage?
}
