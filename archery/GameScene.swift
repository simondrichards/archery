//
//  GameScene.swift
//  archery
//
//  Created by Simon Richards on 21/08/2018.
//  Copyright © 2018 Simon Richards. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var theTarget : SKShapeNode?
    private var theTargett : SKSpriteNode?
    private var spinnyNode : SKShapeNode?
    private var option1Node : SKLabelNode?
    private var hanzi : SKLabelNode?
    private var background : SKSpriteNode?
    private var tile : SKSpriteNode?
    private var settings : SKLabelNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
            label.text = "怎么样？"
            label.position = CGPoint(x: 0.0, y: -100.0)
        }
        
        // Get target node from scene and store it for use later
        self.theTarget = self.childNode(withName: "//target") as? SKShapeNode
        if let theTarget = self.theTarget {
            theTarget.alpha = 0.0
            theTarget.run(SKAction.fadeIn(withDuration: 500.0))
        }
        print("before theTargett")
        self.theTargett = SKSpriteNode()
        if let theTargett = self.theTargett {
            print("theTargett")
            theTargett.texture = SKTexture(imageNamed: "archery_target")
            theTargett.size = theTargett.texture!.size()
            theTargett.size = CGSize(width: 500.0, height: 500.0)
            print (theTargett.size.width)
            theTargett.anchorPoint = CGPoint(x: 0, y: 1)
            theTargett.position = CGPoint(x: -theTargett.size.width/2, y: 500)
            theTargett.zPosition = 5.0
            self.addChild(theTargett)
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        // Create a label node for the options
        let textsize: Int = 50
        var tilesize: Int
        tilesize = textsize + 8
        self.tile = SKSpriteNode.init(color: .red, size: CGSize(width: tilesize, height: tilesize))
        self.hanzi = SKLabelNode.init(text: "Z")
        if let hanzi = self.hanzi {
            hanzi.fontSize = 50
            hanzi.fontName = "STHeitiSC-Medium"  //"PingFangSC-SemiBold"
            hanzi.verticalAlignmentMode = .center
            hanzi.text = "是"
        }
        if let tile = self.tile {
            tile.color = .blue
            tile.position = CGPoint(x: 0.0, y: 250.0)
            tile.zPosition = 10.0
            tile.addChild(self.hanzi!)
            self.addChild(tile)
            print("addChild(tile)")
        }
        
        self.background = SKSpriteNode.init()
        self.option1Node = SKLabelNode.init(text: "A")
        if let option1Node = self.option1Node {
            option1Node.text = "是"
            option1Node.position = CGPoint(x: 0.0, y: 0.0)
            option1Node.alpha = 1.0
            option1Node.fontSize = 100
            self.addChild(option1Node)
        }
        
        // Add a button to get to the settings
        self.settings = SKLabelNode.init(text: "Settings")
        if let settings = self.settings {
            settings.position = CGPoint(x: 0.0, y: 100)
            settings.alpha = 1.0
            settings.fontSize = 50
            self.addChild(settings)
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            label.run(SKAction.moveBy(x: 0.0, y:300.0, duration: 1.0))
         //   label.run(SKAction.moveBy(x: 0.0, y:-100.0, duration: 1.0))
        }
        if let tile = self.tile {
            tile.run(SKAction.moveBy(x: 0.0, y: 250.0, duration: 3.0))
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
