//
//  AppCoordinator.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: CoordinatorProtocol {
    
    var childCoordinators: [CoordinatorProtocol] = []
    
    func addChild(child: CoordinatorProtocol) {
        childCoordinators.append(child)
    }
    
    var viewController: UIViewController?
    
    var parent: CoordinatorProtocol?
    
    private var window = UIWindow(frame: UIScreen.main.bounds)
   
    func start() {

        var vc: CoordinatorProtocol = MovieCatalogCoordinator()
        var rootCoordinator: CoordinatorProtocol = NavigationCoordinator(rootCoordinator: &vc)
        addChild(child: rootCoordinator)
        rootCoordinator.parent = self
        window.rootViewController = rootCoordinator.viewController
        window.makeKeyAndVisible()
    }
    
}
