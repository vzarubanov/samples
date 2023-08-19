//
//  UIViewController+child.swift
//  
//
//  Created by Vasil Zarubanau on 19/08/2023.
//

import UIKit

public extension UIViewController {
    func addChild(viewController: UIViewController, forwardsAppearanceCallbacks: Bool) {
        if forwardsAppearanceCallbacks {
            viewController.beginAppearanceTransition(true, animated: false)
        }
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        if forwardsAppearanceCallbacks {
            viewController.endAppearanceTransition()
        }
        viewController.didMove(toParent: self)
    }

    func removeChild(viewController: UIViewController, forwardsAppearanceCallbacks: Bool) {
        if forwardsAppearanceCallbacks {
            viewController.beginAppearanceTransition(false, animated: false)
        }
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        if forwardsAppearanceCallbacks {
            viewController.endAppearanceTransition()
        }
        viewController.removeFromParent()
    }
}
