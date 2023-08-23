//
//  FilterAttributesViewModel+Filter.swift
//  
//
//  Created by Vasil Zarubanau on 23/08/2023.
//

import Foundation

extension FilterAttributesViewModel {
	init(filter: Filter) {
		self.title = "\(filter.name) attributes:"
		self.sliderAttributes = filter.attributes.numberAttributes.map {
			return .init(
				id: $0.id,
				title: $0.name,
				description: $0.description,
				initialValue: $0.defaultValue,
				range: ClosedRange(uncheckedBounds: ($0.minValue, $0.maxValue))
			)
		}
		self.vectorAttributes = filter.attributes.vectorAttributes.map {
			return .init(
				id: $0.id,
				title: $0.name,
				description: $0.description,
				initialValue: $0.defaultValue
			)
		}
	}
}
