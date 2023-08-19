//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 22/08/2023.
//

import Foundation

struct FilterVectorAttribute {
	struct Vector {
		let x: CGFloat
		let y: CGFloat?
		let z: CGFloat?
		let w: CGFloat?
	}

	let defaultValue: Vector

	let name: String
	let description: String
}
