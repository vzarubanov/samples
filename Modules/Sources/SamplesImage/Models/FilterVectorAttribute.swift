//
//  FilterVectorAttribute.swift
//  
//
//  Created by Vasil Zarubanau on 22/08/2023.
//

import Foundation

struct FilterVectorAttribute: Identifiable {
	struct Vector {
		let x: CGFloat
		let y: CGFloat?
		let z: CGFloat?
		let w: CGFloat?

		static var zero: Vector { .init(x: 0, y: nil, z: nil, w: nil) }
	}

	let id: String
	let name: String
	let description: String
	let defaultValue: Vector
}
