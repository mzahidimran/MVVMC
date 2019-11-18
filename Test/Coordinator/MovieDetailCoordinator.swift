//
//  MovieDetailCoordinator.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit


class MovieDetailCoordinator: BaseCoordinator {
    
    let navigationStack: NavigationStack
    
    var model:MovieVMProtocol {
        get {
            return detailVC.model
        }
        set {
            detailVC.model = newValue
        }
    }
    
    weak private var videoPlayerCoordinator:AVPlayerControllerCoordinator?
    
    private lazy var detailVC: MovieDetailViewController = {
        let detailVC = UIStoryboard(name: Storyboard.Main.rawValue, bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        return detailVC
    }()
    
    init(stack: NavigationStack) {
        self.navigationStack = stack
    }
    
    override func start() {
        detailVC.coordinator = self
        navigationStack.push(self, isAnimated: true, onNavigateBack: didFinish)
    }
}

extension MovieDetailCoordinator: Drawable {
    var viewController: UIViewController? { return detailVC }
}

extension MovieDetailCoordinator: MovieDetailCoordinatorDelegate {
    
    func showVideoPlayer() {
        let videoPlayerCoordinator = AVPlayerControllerCoordinator(presenter: self.viewController!)
        self.videoPlayerCoordinator = videoPlayerCoordinator
        self.store(coordinator: videoPlayerCoordinator)
        videoPlayerCoordinator.didFinish = {[weak self, weak videoPlayerCoordinator] in
            guard let coordinator = videoPlayerCoordinator else { return }
            self?.free(coordinator: coordinator)
        }
        videoPlayerCoordinator.start()
    }
    
    func doneWithVideoPlayer() {
        videoPlayerCoordinator?.finish()
    }
    
    func videoPlayerAddVideo(videoURL: URL) -> Void {
        videoPlayerCoordinator?.videoURL = videoURL
    }
}
