//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 22/08/2023.
//

import Foundation
import CoreImage

extension FilterVectorAttribute {
	init?(CIAttributeDictionary dictionary: [String: Any]) {
		guard
			let name = dictionary[kCIAttributeDisplayName] as? String,
			let description = dictionary[kCIAttributeDescription] as? String,
			let vector = dictionary[kCIAttributeDefault] as? CIVector
		else {
			assertionFailure()
			return nil
		}

		self.name = name
		self.description = description
		self.defaultValue = Vector(
			x: vector.x,
			y: vector.count > 0 ? vector.y : nil,
			z: vector.count > 1 ? vector.z : nil,
			w: vector.count > 2 ? vector.w : nil
		)
	}
}
