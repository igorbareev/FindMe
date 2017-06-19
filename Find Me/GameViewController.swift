//
//  GameViewController.swift
//  Find Me
//
//  Created by Igor on 08.06.17.
//  Copyright © 2017 Igor. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    



    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene()
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                scene.size = CGSize(width: 720, height: 640)
                scene.anchorPoint = CGPoint(x: 0, y: 1)
                // Present the scene
                view.presentScene(scene)
            
// AspectFit твоя картинка впишится в видимую область в соотношении
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
