//
//  Dismissable.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit

protocol Dismissable {
    var didFinish: (() -> ())? { get set }
}
