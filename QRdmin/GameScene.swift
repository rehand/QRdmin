//
//  GameScene.swift
//  PingAnimation
//
//  Created by Handler Reinhard on 23/10/15.
//  Copyright (c) 2015 FH Joanneum. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Pinging device..."
        myLabel.fontSize = 100
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + CGRectGetMidY(self.frame) / 2 * 3)
        
        self.addChild(myLabel)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func showResult(success: Bool) {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        
        if success {
            myLabel.text = "Device reachable!"
            myLabel.fontColor = UIColor.greenColor()
        } else {
            myLabel.text = "Device unreachable!"
            myLabel.fontColor = UIColor.redColor()
        }

        myLabel.fontSize = 85
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - CGRectGetMidY(self.frame) / 2 * 3)
        
        self.addChild(myLabel)
    }
}
