//
//  Drawable.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { return self }
}
