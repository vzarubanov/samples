//
//  FilterNumberAttribute.swift
//  
//
//  Created by Vasil Zarubanau on 22/08/2023.
//

import Foundation

struct FilterNumberAttribute: Identifiable {
	let id: String
	let name: String
	let description: String
	let minValue: CGFloat
	let maxValue: CGFloat
	let defaultValue: CGFloat
}
