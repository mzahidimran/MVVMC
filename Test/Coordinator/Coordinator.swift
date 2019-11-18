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


protocol CoordinatorProtocol {
    var parent:CoordinatorProtocol? { get set }
    var viewController: UIViewController? { get }
    var childCoordinators: [CoordinatorProtocol] { get }
    func addChild(child: CoordinatorProtocol) -> Void
    func start()
}




