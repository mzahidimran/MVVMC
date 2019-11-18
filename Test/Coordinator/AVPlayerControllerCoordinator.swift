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
    
    let presenter: UIViewController
    
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
    
    init(presenter: UIViewController) {
        self.presenter = presenter
        super.init()
    }

    
    func finish() -> Void {
        self.avplayerVC.dismiss(animated: true, completion:nil)
    }
    
    override func start() {
        avplayerVC.didFinish = self.didFinish
        presenter.present(avplayerVC, animated: true, completion: nil)
    }
    
}

extension AVPlayerControllerCoordinator: Drawable {
    var viewController: UIViewController? {
        return avplayerVC
    }
}

