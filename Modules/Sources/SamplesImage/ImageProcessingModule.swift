//
//  ImageProcessingModule.swift
//  
//
//  Created by Vasil Zarubanau on 19/08/2023.
//

import UIKit

public protocol ImageProcessingModuleProtocol {
	var router: ImageProcessingRouterProtocol { get }
}

public final class ImageProcessingModule: ImageProcessingModuleProtocol {
  public struct Injection {
    public init() {}
  }

	@MainActor
	private lazy var _router = { ImageProcessingRouter() }()
	@MainActor
	public var router: ImageProcessingRouterProtocol { _router }

	public init(_ dependencies: Injection) {
  }
}
