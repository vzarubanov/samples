//
//  FilterAttributesViewModel.swift
//  
//
//  Created by Vasil Zarubanau on 22/08/2023.
//

import Foundation
import Combine

struct FilterAttributesViewModel {

	struct SliderAttributesViewModel: Identifiable {
		let id: String
		let title: String
		let description: String

		let initialValue: CGFloat
		let range: ClosedRange<CGFloat>

		let value: PassthroughSubject<CGFloat, Never> = PassthroughSubject()

		internal init(id: String, title: String, description: String, initialValue: CGFloat, range: ClosedRange<CGFloat>) {
			self.id = id
			self.title = title
			self.description = description
			self.initialValue = initialValue
			self.range = range
		}
	}

	struct VectorAttributesViewModel: Identifiable {
		let id: String
		let title: String
		let description: String

		let initialValue: FilterVectorAttribute.Vector
		let value: PassthroughSubject<FilterVectorAttribute.Vector, Never> = PassthroughSubject()

		internal init(id: String, title: String, description: String, initialValue: FilterVectorAttribute.Vector) {
			self.id = id
			self.title = title
			self.description = description
			self.initialValue = initialValue
		}
	}

	let title: String
	let sliderAttributes: [SliderAttributesViewModel]
	let vectorAttributes: [VectorAttributesViewModel]
}
