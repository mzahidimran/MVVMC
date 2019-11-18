//
//  AppCoordinator.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() {
        
        let navigationController = UINavigationController()
        let navigationStack = NavigationStack(navigationController: navigationController)
        let catalogCoordinator = MovieCatalogCoordinator(stack: navigationStack)
        self.store(coordinator: catalogCoordinator)
        catalogCoordinator.start()
        navigationStack.push(catalogCoordinator, isAnimated: true) { [weak self, weak catalogCoordinator] in
            guard let `self` = self, let myCoordinator = catalogCoordinator else { return }
            self.free(coordinator: myCoordinator)
        }
        window.rootViewController = navigationStack.navigationController
        window.makeKeyAndVisible()
    }
    
}
