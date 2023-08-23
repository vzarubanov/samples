//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 22/08/2023.
//

import Foundation
import CoreImage

extension FilterVectorAttribute {
	init?(inputKey: String, attributeDictionary dictionary: [String: Any]) {
		guard
			let name = dictionary[kCIAttributeDisplayName] as? String,
			let description = dictionary[kCIAttributeDescription] as? String,
			let vector = dictionary[kCIAttributeDefault] as? CIVector
		else {
			assertionFailure()
			return nil
		}

		self.id = inputKey
		self.name = name
		self.description = description
		self.defaultValue = Vector(ciVector: vector)
	}
}

extension FilterVectorAttribute.Vector {
	init(ciVector vector: CIVector) {
		self.x = vector.x
		self.y = vector.count > 0 ? vector.y : nil
		self.z = vector.count > 1 ? vector.z : nil
		self.w = vector.count > 2 ? vector.w : nil
	}

	var ciVector: CIVector {
		guard let y else { return CIVector(x: x) }
		guard let z else { return CIVector(x: x, y: y) }
		guard let w else { return CIVector(x: x, y: y, z: z) }
		return CIVector(x: x, y: y, z: z, w: w)
	}
}
