//
//  ForceField.swift
//  DemoSceneEditor
//
//  Created by David Witter on 3/2/15.
//  Copyright (c) 2015 David Witter. All rights reserved.
//

import SpriteKit

class Fields: SKScene {
    
    var playerSprite: SKSpriteNode?
    var playerLight: SKLightNode?
    var booster: SKEmitterNode?

    override func didMoveToView(view: SKView) {
        // Set a scene boundary
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)

        // Get the player sprite (once again, most of the sprite's properties
        // are being set via the scene editor, so minimal work has to be done here.
        playerSprite = childNodeWithName("astroguy") as? SKSpriteNode
        playerLight = childNodeWithName("playerLight") as? SKLightNode
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        // Add booster particle
        booster = SKEmitterNode(fileNamed: "BoosterParticle.sks")
        booster!.position = playerSprite!.position
        booster!.zPosition = 1
        addChild(booster!)
        
        // Launch the player sprite upward
        let launch = SKAction.moveBy(CGVectorMake(0, 100), duration: 0.6)
        playerSprite?.runAction(launch)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {

    }
    
    override func update(currentTime: NSTimeInterval) {
        //playerLight?.position = playerSprite!.position
        
        if let booster = booster {
            booster.position = playerSprite!.position
        }
    }
    

}
