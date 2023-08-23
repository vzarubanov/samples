//
//  ImageProcessingSliderAttributeView.swift
//  
//
//  Created by Vasil Zarubanau on 23/08/2023.
//

import SwiftUI

struct ImageProcessingSliderAttributeView: View {
	private let viewModel: FilterAttributesViewModel.SliderAttributesViewModel

	@State private var value: CGFloat

	init(viewModel: FilterAttributesViewModel.SliderAttributesViewModel) {
		self.viewModel = viewModel
		self._value = State(initialValue: viewModel.initialValue)
	}

    var body: some View {
			ZStack {
				Color.white
				VStack(alignment: .leading) {
					HStack {
						Text(viewModel.title)
							.font(.callout)
						Spacer()
						Text("\(value)")
							.foregroundColor(.teal)
					}

					Slider(value: $value, in: viewModel.range) { isEditing in
						guard !isEditing else { return }
						viewModel.value.send(value)
					}
					Text(viewModel.description)
						.font(.caption)
						.foregroundColor(.secondary)
						.multilineTextAlignment(.leading)
				}
				.padding()
			}
			.cornerRadius(10)
			.fixedSize(horizontal: false, vertical: true)
    }
}
