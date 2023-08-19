//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 22/08/2023.
//

import Foundation
import CoreImage

extension FilterNumberAttribute {
	init?(CIAttributeDictionary dictionary: [String: Any]) {
		guard
			let name = dictionary[kCIAttributeDisplayName] as? String,
			let description = dictionary[kCIAttributeDescription] as? String,
			let defaultValue = dictionary[kCIAttributeDefault] as? Double,
			let minValue = dictionary[kCIAttributeSliderMin] as? Double,
			let maxValue = dictionary[kCIAttributeSliderMax] as? Double
		else {
			assertionFailure()
			return nil
		}

		self.name = name
		self.description = description
		self.defaultValue = defaultValue
		self.minValue = minValue
		self.maxValue = maxValue
	}
}
