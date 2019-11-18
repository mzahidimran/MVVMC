//
//  PlayerViewController.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/18/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class PlayerViewController: AVPlayerViewController, Dismissable {
    
    var didFinish: (() -> ())?
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        self.didFinish?()
    }
    
}


