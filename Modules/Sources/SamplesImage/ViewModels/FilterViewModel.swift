//
//  FilterViewModel.swift
//  
//
//  Created by Vasil Zarubanau on 21/08/2023.
//

import Foundation
import UIKit

struct FilterViewModel {
	let filter: Filter

	let title: String
	let thumbnail: UIImage?
	var isSelected: Bool
}

extension FilterViewModel: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(filter.id)
		hasher.combine(isSelected)
		hasher.combine(thumbnail)
		hasher.combine(title)
	}
}

extension FilterViewModel: Equatable {
	static func == (lhs: FilterViewModel, rhs: FilterViewModel) -> Bool {
		lhs.filter.id == rhs.filter.id &&
		lhs.title == rhs.title &&
		lhs.thumbnail == rhs.thumbnail &&
		lhs.isSelected == rhs.isSelected
	}

}
