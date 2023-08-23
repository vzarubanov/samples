//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 22/08/2023.
//

import Foundation
import CoreImage

// MARK: - Convenience

extension Filter {
	static let skipAttributes: [String] = [kCIInputImageKey, kCIOutputImageKey]

	init?(CIAttributesDictionary dictionary: [String: Any]) {
		guard
			let id = dictionary[kCIAttributeFilterName] as? String,
			let filterName = dictionary[kCIAttributeFilterDisplayName] as? String else { return nil }

		var numberAttributes: [FilterNumberAttribute] = []
		var vectorAttributes: [FilterVectorAttribute] = []

		for (key, attribute) in dictionary where !Self.skipAttributes.contains(key) {
			guard
				let attributeDict = attribute as? [String: Any],
				let typeName = attributeDict[kCIAttributeClass] as? String
			else { continue }

			switch typeName {
			case "NSNumber":
				guard let numberAttribute = FilterNumberAttribute(inputKey: key, attributeDictionary: attributeDict) else { continue }
				numberAttributes.append(numberAttribute)
			case "CIVector":
				guard let vectorAttribute = FilterVectorAttribute(inputKey: key, attributeDictionary: attributeDict) else { continue }
				vectorAttributes.append(vectorAttribute)
			case "CIImage":
				continue
			default:
				assertionFailure("unknown attribute type \(typeName) for key \(key): \(attributeDict)")
				continue
			}
		}

		guard !numberAttributes.isEmpty || !vectorAttributes.isEmpty else { return nil }

		self.id = id
		self.name = filterName
		self.attributes = FilterAttributes(
			numberAttributes: numberAttributes,
			 vectorAttributes: vectorAttributes
		 )
	}
}
