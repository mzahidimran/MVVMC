//
//  AVPlayerControllerCoordinator.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class AVPlayerControllerCoordinator: BaseCoordinator {
    
    lazy var avplayerVC: PlayerViewController = {
        let playerVC = PlayerViewController()
        return playerVC
    }()
    
    var videoURL:URL? {
        didSet {
            guard let url = videoURL else {
                return
            }
            let player = AVPlayer(url: url)
            self.avplayerVC.player = player
            self.avplayerVC.player?.play()
        }
    }
    
    func start(presenter: UIViewController) {
        avplayerVC.didFinish = self.didFinish
        presenter.present(avplayerVC, animated: true, completion: nil)
    }
    
    func finish() -> Void {
        self.avplayerVC.dismiss(animated: true, completion:nil)
    }
    
    internal override func start() {
        avplayerVC.didFinish = self.didFinish
    }
    
}

extension AVPlayerControllerCoordinator: Drawable {
    var viewController: UIViewController? {
        return avplayerVC
    }
}

