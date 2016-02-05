//
//  GameViewController.swift
//  PingAnimation
//
//  Created by Handler Reinhard on 23/10/15.
//  Copyright (c) 2015 FH Joanneum. All rights reserved.
//

import UIKit
import SpriteKit

class PingAnimationViewController: UIViewController {
    
    @IBOutlet weak var pingAnimationView: SKView!
    
    var device : Device?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(fileNamed:"GameScene")
        
        if scene != nil {
            // Configure the view.
            pingAnimationView.showsFPS = false
            pingAnimationView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            pingAnimationView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene?.scaleMode = .AspectFit
            
            pingAnimationView.presentScene(scene)
        }
        
        if device != nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                Ping(hostNameOrIpAddress: self.device!.ip) {
                    (success) -> Void in
                    NSLog("Pinging " + self.device!.ip + ", success: " + success.description)
                    
                    scene?.showResult(success)
                    
                    //self.pingAnimationView.paused = true
                    //self.pingAnimationView.scene?.paused = true
                }
            }
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
