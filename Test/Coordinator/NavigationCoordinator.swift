//
//  NavigationController.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit

class NavigationCoordinator: BaseViewControllerCoordinator {
    
    private var navigationController: UINavigationController?
    
    override var viewController: UIViewController? {
        return navigationController
    }
    
    init(rootCoordinator: inout CoordinatorProtocol) {
        super.init()
        self.addChild(child: rootCoordinator)
        rootCoordinator.parent = self
        if let controller = rootCoordinator.viewController {
            navigationController = UINavigationController(rootViewController: controller)
        }
    }
    
}
