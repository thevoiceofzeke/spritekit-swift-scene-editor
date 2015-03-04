//
//  SpaceTest.swift
//  DemoSceneEditor
//
//  Created by David Witter on 3/2/15.
//  Copyright (c) 2015 David Witter. All rights reserved.
//


import SpriteKit

class SpaceTest: SKScene {
    
    // Astronaut reference
    var astronaut: SKSpriteNode?
    
    // Field reference
    var field: SKFieldNode?
    var fieldSprite: SKSpriteNode?
    
    // Button references
    var linearButton    :   SKNode?
    var radialButton    :   SKNode?
    var vortexButton    :   SKNode?
    var springButton    :   SKNode?
    var falloffUp       :   SKNode?
    var falloffDown     :   SKNode?
    var strengthUp      :   SKNode?
    var strengthDown    :   SKNode?
    var regionUp        :   SKNode?
    var regionDown      :   SKNode?
    
    // HUD References
    var fieldTypeLabel      :   SKLabelNode?
    var fieldStrengthLabel  :   SKLabelNode?
    var fieldFalloffLabel   :   SKLabelNode?
    var fieldPositionLabel  :   SKLabelNode?
    var fieldRegionLabel    :   SKLabelNode?
    
    // Stored values
    var currentFalloff: Float?
    var currentStrength: Float?
    var currentRegionSize: CGSize?
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Create an edge-based body the size of the scene.
        let border = SKPhysicsBody(edgeLoopFromRect: self.frame)
        // Set any border properties
        border.friction = 0
        // Make it the scene's physicsBody
        self.physicsBody = border
        
        
        /////////////////////////////
        // ESTABLISHING REFERENCES //
        /////////////////////////////
        // Get astronaut
        astronaut           = childNodeWithName("astronaut") as? SKSpriteNode
        
        // Get the scene's field node
        field               = childNodeWithName("field") as? SKFieldNode
        fieldSprite         = childNodeWithName("fieldSprite") as? SKSpriteNode
        
        // Get the buttons
        linearButton        = childNodeWithName("linearButton")
        radialButton        = childNodeWithName("radialButton")
        vortexButton        = childNodeWithName("vortexButton")
        springButton        = childNodeWithName("springButton")
        falloffUp           = childNodeWithName("falloffUp")
        falloffDown         = childNodeWithName("falloffDown")
        strengthUp          = childNodeWithName("strengthUp")
        strengthDown        = childNodeWithName("strengthDown")
        regionUp            = childNodeWithName("regionUp")
        regionDown          = childNodeWithName("regionDown")
        
        // Get HUD elements
        fieldTypeLabel      = childNodeWithName("fieldType") as? SKLabelNode
        fieldStrengthLabel  = childNodeWithName("fieldStrength") as? SKLabelNode
        fieldFalloffLabel   = childNodeWithName("fieldFalloff") as? SKLabelNode
        fieldPositionLabel  = childNodeWithName("fieldPosition") as? SKLabelNode
        fieldRegionLabel    = childNodeWithName("fieldRegion") as? SKLabelNode
        
        currentStrength = field!.strength
        currentFalloff = field!.falloff
        currentRegionSize = frame.size
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        // Get the location touched
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        // Get the sprite at that location
        let touchedNode = self.nodeAtPoint(location)
        //println("touched: \(touchedNode.name)")
        
        // If the sprite is one of our buttons, change the field type
        switch touchedNode {
            
            // FIELD BUTTONS //
        case linearButton!:
            changeToDragField()
            fieldTypeLabel!.text = "Type: Drag"
            fieldSprite!.texture = SKTexture(imageNamed: "linearField.png")
        case radialButton!:
            changeFieldToType(SKFieldNode.radialGravityField())
            fieldTypeLabel!.text = "Type: Radial"
            fieldSprite!.texture = SKTexture(imageNamed: "radialField.png")
        case vortexButton!:
            changeFieldToType(SKFieldNode.vortexField())
            fieldTypeLabel!.text = "Type: Vortex"
            fieldSprite!.texture = SKTexture(imageNamed: "vortex.png")
        case springButton!:
            changeFieldToType(SKFieldNode.springField())
            fieldTypeLabel!.text = "Type: Spring"
            fieldSprite!.texture = SKTexture(imageNamed: "springField.png")
            
            // MODIFIER BUTTONS //
        case falloffUp!:
            incrementFieldFalloff(1.0)
        case falloffDown!:
            incrementFieldFalloff(-1.0)
        case strengthUp!:
            incrementFieldStrength(1.0)
        case strengthDown!:
            incrementFieldStrength(-1.0)
        case regionUp!:
            incrementFieldRegion(50.0)
        case regionDown!:
            incrementFieldRegion(-50.0)
            
            
            // DEFAULT //
        default:
            println("selected: \(touchedNode.description)")
            /*
            Note:
            Cannot access SKLinearGravityFieldNode -- should be able to do this:
            changeFieldToType(SKFieldNode.linearGravityFieldWithVector(0, -9.8))
            */
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        field!.position = location
        fieldSprite!.position = location
        
    }
    
    /////////////////////////
    // CHANGING FIELD TYPE //
    /////////////////////////
    func changeToDragField() {
        field?.removeFromParent()
        
        field = SKFieldNode.dragField()
        field?.strength = 5.0
        field?.falloff = 1.0
        field?.position = CGPoint(x: 512, y: 384)
        field?.region = SKRegion(size: currentRegionSize!)
        
        addChild(field!)
    }
    
    func changeFieldToType(node: SKFieldNode) {
        // Remove existing field from scene.
        field?.removeFromParent()
        // Set our node on screen to the new node.
        field = node
        // Give the node standard properties
        field?.position = CGPoint(x: 512, y: 384)
        field?.strength = currentStrength!
        field?.falloff = currentFalloff!
        // Make the field node affect the whole scene
        field?.region = SKRegion(size: currentRegionSize!)
        
        
        addChild(field!)
        
        //println("end type: \(field)")
    }
    
    
    
    //////////////////
    // UPDATING HUD //
    //////////////////
    func incrementFieldStrength(strength: Float) {
        if let field = field {
            field.strength += strength
            currentStrength = field.strength
        }
    }
    
    func incrementFieldFalloff(falloff: Float) {
        if let field = field {
            field.falloff += falloff
            currentFalloff = field.falloff
        }
    }
    
    func incrementFieldRegion(difference: CGFloat) {
        var height = currentRegionSize!.height + difference
        var width = currentRegionSize!.width + difference
        
        if height <= 0 {
            currentRegionSize!.height = 0
            height = 0
        } else {
            currentRegionSize!.height += difference
        }
        
        if width <= 0 {
            currentRegionSize!.width = 0
            width = 0
        } else {
            currentRegionSize!.width += difference
        }
        
        
        if let field = field {
            let newSize = CGSize(width: width, height: height)
            field.region = SKRegion(size: newSize)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        fieldFalloffLabel?.text = "\(field!.falloff)"
        fieldStrengthLabel?.text = "\(field!.strength)"
        fieldPositionLabel?.text = "Position: \(field!.position)"
        
        var size = currentRegionSize!
        let sizeString = "\(size.width), \(size.height)"
        fieldRegionLabel?.text = "\(sizeString)"
    }
}



