import UIKit
import SamplesImage
import SamplesVideo

public protocol RootModuleProtocol {
	var router: RootRouterProtocol { get }
}

public final class RootModule: RootModuleProtocol {

	private let builder: RootBuilder
	@MainActor
	private lazy var _router: RootRouterProtocol = { RootRouter(builder: builder) }()
	@MainActor
	public var router: RootRouterProtocol { _router }

	public init(_ dependencies: Injection) {
		self.builder = RootBuilder(dependencies)
	}
}

public extension RootModule {
	struct Injection {
		let imageModule: ImageProcessingModule
		let videoModule: VideoProcessingModule

		public static func make() -> Injection {
			let imageModule = ImageProcessingModule(.init())
			let videoModule = VideoProcessingModule(.init())

			return .init(
				imageModule: imageModule,
				videoModule: videoModule
			)
		}
	}
}
