//
//  BaseCoordinator.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation

class BaseCoordinator : Coordinator, Dismissable {
    var childCoordinators : [Coordinator] = []
    var didFinish: (() -> ())?

    func start() {
        fatalError("Children should implement `start`.")
    }
}
