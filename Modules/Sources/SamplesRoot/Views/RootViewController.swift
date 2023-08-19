//
//  File.swift
//  
//
//  Created by Vasil Zarubanau on 17/08/2023.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
  private var presenter: RootPresenterProtocol!
  
  init(presenter: RootPresenterProtocol) {
    super.init(nibName: nil, bundle: nil)
    self.presenter = presenter
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let label = UILabel(frame: view.bounds)
    label.text = "Hello"
    label.textAlignment = .center
    
    view.addSubview(label)
    view.backgroundColor = .white
  }
}
