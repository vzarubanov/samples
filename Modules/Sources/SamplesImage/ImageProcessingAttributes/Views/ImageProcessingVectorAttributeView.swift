//
//  ImageProcessingVectorAttributeView.swift
//  
//
//  Created by Vasil Zarubanau on 23/08/2023.
//

import SwiftUI

struct ImageProcessingVectorAttributeView: View {
	private let viewModel: FilterAttributesViewModel.VectorAttributesViewModel
	init(viewModel: FilterAttributesViewModel.VectorAttributesViewModel) {
		self.viewModel = viewModel
		self._x = State(initialValue: viewModel.initialValue.x)
		if let y = viewModel.initialValue.y {
			self._y = State(initialValue: y)
		}
		if let z = viewModel.initialValue.z {
			self._z = State(initialValue: z)
		}
		if let w = viewModel.initialValue.w {
			self._w = State(initialValue: w)
		}
	}

	@State var x: CGFloat
	@State var y: CGFloat = 0
	@State var z: CGFloat = 0
	@State var w: CGFloat = 0

	var body: some View {
		ZStack {
			Color.white
			VStack(alignment: .leading) {
				HStack {
					Text(viewModel.title)
						.font(.callout)
					Spacer()
					prepareValueView()
						.foregroundColor(.teal)
				}

				prepareVectorView()
					.font(.callout)

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

	private func prepareVectorView() -> some View {
		VStack {
			HStack {
				Text("x:")
				Slider(value: $x, in: 0...150, step: 1)
			}

			if viewModel.initialValue.y != nil {
				HStack {
					Text("y:")
					Slider(value: $y, in: 0...150, step: 1)
				}
			}

			if viewModel.initialValue.z != nil {
				HStack {
					Text("z:")
					Slider(value: $z, in: 0...150, step: 1)
				}
			}

			if viewModel.initialValue.w != nil {
				HStack {
					Text("w:")
					Slider(value: $w, in: 0...150, step: 1)
				}
			}
		}
	}

	private func prepareValueView() -> some View {
		let valueString = [x,
											 viewModel.initialValue.y != nil ? y : nil,
											 viewModel.initialValue.z != nil ? z : nil,
											 viewModel.initialValue.w != nil ? w : nil].compactMap {
			$0
		}.map { "\($0)" }.joined(separator: " ")
		return Text("[\(valueString)]")
	}
}

struct ImageProcessingVectorAttributeView_Previews: PreviewProvider {
	static var previews: some View {
		ImageProcessingVectorAttributeView(
			viewModel: .init(
				id: "1",
				title: "Center",
				description: "Vector",
				initialValue: .init(x: 150, y: 150, z: nil, w: nil)
			)
		)
	}
}
