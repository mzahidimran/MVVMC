//
//  BaseViewControllerCoordinator.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit

class BaseViewControllerCoordinator: CoordinatorProtocol {
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    func addChild(child: CoordinatorProtocol) {
        childCoordinators.append(child)
    }
    
    var viewController: UIViewController? {
        return nil
    }
    
    var parent: CoordinatorProtocol?
    
    func start() {
        if let controller = parent?.viewController, let viewController = viewController {
            if let navigation = controller as? UINavigationController {
                navigation.pushViewController(viewController, animated: true)
            }
            else {
                controller.present(viewController, animated: true, completion: nil)
            }
        }
    }
}
