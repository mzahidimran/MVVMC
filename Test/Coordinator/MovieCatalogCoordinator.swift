//
//  MovieCatalogCoordinator.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit

protocol MovieCatalogCoordinatorDelegate: class {
    func didSelect(movieVM: MovieVMProtocol) -> Void
}

class MovieCatalogCoordinator: BaseViewControllerCoordinator {
    
    private var catalogVC: MovieCatalogViewController?
    
    override var viewController: UIViewController? {
        return catalogVC
    }
    
    override init() {
        super.init()
        catalogVC = UIStoryboard(name: Storyboard.Main.rawValue, bundle: nil).instantiateViewController(withIdentifier: "MovieCatalogViewController") as? MovieCatalogViewController
        catalogVC?.model = MovieCatalogVM()
        catalogVC?.coordinator = self
    }
    
}

extension MovieCatalogCoordinator: MovieCatalogCoordinatorDelegate {
    func didSelect(movieVM: MovieVMProtocol) {
        let movieDetail = MovieDetailCoordinator(model: movieVM)
        addChild(child: movieDetail)
        movieDetail.parent = self.parent
        movieDetail.start()
    }
}
