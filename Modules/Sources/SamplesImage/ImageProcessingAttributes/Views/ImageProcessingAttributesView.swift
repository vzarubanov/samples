//
//  ImageProcessingAttributesView.swift
//  
//
//  Created by Vasil Zarubanau on 23/08/2023.
//

import SwiftUI

struct ImageProcessingAttributesView: View {
	private let viewModel: ImageProcessingAttributesViewModelProcotol
	init(viewModel: ImageProcessingAttributesViewModelProcotol) {
		self.viewModel = viewModel
	}

	var body: some View {
		ZStack {
			Color.gray
			VStack(alignment: .leading) {
				Text(viewModel.attributes.title)
					.padding([.top, .horizontal], 20)

				ForEach(viewModel.attributes.sliderAttributes, id: \.title) { attribute in
					ImageProcessingSliderAttributeView(viewModel: attribute)
						.padding(.horizontal, 20)
						.padding(.vertical, 5)
				}

				ForEach(viewModel.attributes.vectorAttributes, id: \.title) { attribute in
					ImageProcessingVectorAttributeView(viewModel: attribute)
						.padding(.horizontal, 20)
						.padding(.vertical, 5)
				}

				Spacer()
			}
		}
	}
}

#if os(iOS)

struct ImageProcessingAttributesView_Previews: PreviewProvider {
	static var previews: some View {
		let attributes = FilterAttributes(
			numberAttributes: [
				.init(
					id: "0",
					name: "Radius", description: "This is description",
					minValue: 0, maxValue: 1, defaultValue: 0.5
				)
			],
			vectorAttributes: [
				.init(
					id: "1",
					name: "Center", description: "Vector",
					defaultValue: .init(x: 150, y: 150, z: nil, w: nil)
				)
			]
		)

		let filter = Filter(id: "1", name: "Test Filter", attributes: attributes)
		let viewModel = ImageProcessingAttributesViewModel(filter: filter, delegate: nil)
		ImageProcessingAttributesView(viewModel: viewModel)
	}
}

#endif
