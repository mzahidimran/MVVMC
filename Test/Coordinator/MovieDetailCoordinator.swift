//
//  MovieDetailCoordinator.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit


class MovieDetailCoordinator: BaseViewControllerCoordinator {
    
    private var catalogVC: MovieDetailViewController?
    
    override var viewController: UIViewController? {
        return catalogVC
    }
    
    init(model: MovieVMProtocol) {
        catalogVC = UIStoryboard(name: Storyboard.Main.rawValue, bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController
        catalogVC?.model = model
    }
    
    
}
