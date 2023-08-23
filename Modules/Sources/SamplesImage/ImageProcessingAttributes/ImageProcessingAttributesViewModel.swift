//
//  ImageProcessingAttributesViewModel.swift
//  
//
//  Created by Vasil Zarubanau on 23/08/2023.
//

import Foundation
import Combine

protocol ImageProcessingAttributesViewModelDelegate: AnyObject {
	func attributesViewModelDidReceive(value: CGFloat, forAttributeId: String)
	func attributesViewModelDidReceive(value: FilterVectorAttribute.Vector, forAttributeId: String)
}

protocol ImageProcessingAttributesViewModelProcotol {
	var attributes: FilterAttributesViewModel { get }
}

final class ImageProcessingAttributesViewModel: ImageProcessingAttributesViewModelProcotol {
	let attributes: FilterAttributesViewModel

	private weak var delegate: ImageProcessingAttributesViewModelDelegate?
	private var bag = Set<AnyCancellable>()

	init(filter: Filter, delegate: ImageProcessingAttributesViewModelDelegate?) {
		self.attributes = FilterAttributesViewModel(filter: filter)
		self.delegate = delegate

		attributes.sliderAttributes.forEach { attribute in
			attribute.value.sink { [weak self] value in
				self?.delegate?.attributesViewModelDidReceive(value: value, forAttributeId: attribute.id)
			}.store(in: &bag)
		}

		attributes.vectorAttributes.forEach { attribute in
			attribute.value.sink { [weak self] value in
				self?.delegate?.attributesViewModelDidReceive(value: value, forAttributeId: attribute.id)
			}.store(in: &bag)
		}
	}
}
