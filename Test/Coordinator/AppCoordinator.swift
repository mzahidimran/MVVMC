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
        catalogCoordinator.didFinish = {[weak self, weak catalogCoordinator] in
            guard let coordinator = catalogCoordinator else { return }
            self?.free(coordinator: coordinator)
        }
        catalogCoordinator.start()
        
        window.rootViewController = navigationStack.navigationController
        window.makeKeyAndVisible()
    }
    
}
