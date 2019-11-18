//
//  Coordinator.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard: String {
    case Main
}


protocol Coordinator: class {
    var childCoordinators : [Coordinator] { get set }
    func start()
}

extension Coordinator {

    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}



