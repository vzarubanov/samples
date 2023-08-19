//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 17/08/2023.
//

import Foundation

public protocol RootPresenterProtocol {
}

final class RootPresenter: RootPresenterProtocol {
  internal init() {
    
  }
  weak var view: RootViewController?
}
