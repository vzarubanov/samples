//
//  FilterAttributesViewModel.swift
//  
//
//  Created by Vasil Zarubanau on 22/08/2023.
//

import Foundation

struct FilterAttributesViewModel {

	struct SliderAttributesViewModel {
		let title: String
		let description: String

		let sliderRange: ClosedRange<CGFloat>
		let sliderValue: CGFloat
	}

	struct VectorAttributesViewModel {
		let title: String
		let description: String

		let value: FilterVectorAttribute.Vector
	}

	let title: String
	let sliderAttributes: [SliderAttributesViewModel]
	let vectorAttributes: [VectorAttributesViewModel]
}
