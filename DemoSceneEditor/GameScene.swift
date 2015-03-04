//
//  GameScene.swift
//  DemoSceneEditor
//
//  Created by David Witter on 3/2/15.
//  Copyright (c) 2015 David Witter. All rights reserved.
//

import SpriteKit

struct SpriteTypes {
    static let Protagonist  :   String = "square"
    static let Inanimate    :   String = "object"
}


class GameScene: SKScene {
    
    
    let fieldMask: UInt32 = 1
    let categoryMask: UInt32 = 1
    var forceField: SKFieldNode?
    
    
    var playerSprite: SKSpriteNode?
    var playerSelected: Bool?
    
    override func didMoveToView(view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        // Get reference to player sprite (minimal effort, since most of the work is still done 
        // in the scene editor
        playerSprite = childNodeWithName("squarepants") as? SKSpriteNode

        playerSelected = false
        
        
        
        /////////////////
        // FORCE FIELD //
        /////////////////
        // Enable the scene's radial gravity field
        forceField = childNodeWithName("forceField") as? SKFieldNode
        forceField?.enabled = true
        //forceField?.physicsBody = SKPhysicsBody(circleOfRadius: 100)
        forceField?.region = SKRegion(radius: 100)
        
        
        
        generateShapes()
    }
    
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        let touchedNode = nodeAtPoint(location)
        
        if touchedNode == playerSprite {
            playerSelected = true
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        if playerSelected == true {
            playerSprite?.position = location
            forceField?.position = location
        }
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        playerSelected = false
    }
    
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random_uniform(UInt32(size.width)) + 1))
    }
    
    func generateShapes() {
        for count in 1 ... 100 {
            let shape = SKShapeNode(rectOfSize: CGSizeMake(30, 30))
            shape.strokeColor = UIColor.whiteColor()
            shape.lineWidth = 5.0
            shape.position = CGPointMake(random(), size.height - 10)
            

            addChild(shape)
            
            shape.physicsBody = SKPhysicsBody(rectangleOfSize: shape.frame.size)
            shape.physicsBody?.fieldBitMask = fieldMask
            shape.physicsBody?.mass = 0.9
            shape.physicsBody?.affectedByGravity = true
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        
    }
}
