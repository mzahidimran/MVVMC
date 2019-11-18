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

class MovieCatalogCoordinator: BaseCoordinator {
    
    let navigationStack: NavigationStack
    
    private lazy var catalogVC: MovieCatalogViewController = {
        let catalogVC = UIStoryboard(name: Storyboard.Main.rawValue, bundle: nil).instantiateViewController(withIdentifier: "MovieCatalogViewController") as! MovieCatalogViewController
        catalogVC.model = MovieCatalogVM()
        return catalogVC
    }()
    
    init(stack: NavigationStack) {
        self.navigationStack = stack
    }
    
    func showMovieDetail(vm: MovieVMProtocol) -> Void {
        let movieDetailCoordinator = MovieDetailCoordinator(stack: navigationStack)
        movieDetailCoordinator.start(vm)
        self.store(coordinator: movieDetailCoordinator)
        navigationStack.push(movieDetailCoordinator, isAnimated: true) { [weak self, weak movieDetailCoordinator] in
            guard let `self` = self, let myCoordinator = movieDetailCoordinator else { return }
            self.free(coordinator: myCoordinator)
        }
    }
    
    override func start() {
        catalogVC.coordinator = self
    }
}

extension MovieCatalogCoordinator: MovieCatalogCoordinatorDelegate {
    func didSelect(movieVM: MovieVMProtocol) {
        showMovieDetail(vm: movieVM)
    }
}

extension MovieCatalogCoordinator: Drawable {
    var viewController: UIViewController? { return catalogVC }
}
