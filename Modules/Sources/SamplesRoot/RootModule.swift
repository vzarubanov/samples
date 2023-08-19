import UIKit

public protocol RootModuleProtocol {
  func makeViewController() -> UIViewController
}

public struct RootModule: RootModuleProtocol {
  public struct Injection {
    public init() {}
  }
    
  private let builder: RootBuilder

  public init(_ dependencies: Injection) {
    self.builder = RootBuilder(dependencies)
  }
  
  public func makeViewController() -> UIViewController {
    let router = builder.buildRouter()
    let presenter = builder.buildPresenter()
    let view = RootViewController(presenter: presenter)
    presenter.view = view
    
    return view
  }
}
