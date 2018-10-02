//
//  GameScene.swift
//  archery
//
//  Created by Simon Richards on 21/08/2018.
//  Copyright © 2018 Simon Richards. All rights reserved.
//

import SpriteKit
import GameplayKit

/*
class answerTile: SKSpriteNode {
    
    private var tile : SKSpriteNode?
    private var hanzi : SKLabelNode?
    private var key: String
    private var value: String
    
    var wordKey: String
    var wordValue: String
    
    init(key: String, value: String) {
        self.wordKey = key
        self.wordValue = value
        super.init(texture: nil, color: .white, size: CGSize(width: 50, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func create(dictionaryKey: String, dictionaryValue: String) {
        
        // Create a tile for the candidate answers
        
        let textsize: Int = 50
        var tilesize: Int
        
        // Make tile big enough for two characters
        tilesize = 3*textsize + 8
        
        self.tile = SKSpriteNode.init(color: .red, size: CGSize(width: tilesize, height: textsize+8))
        self.hanzi = SKLabelNode.init()
        if let hanzi = self.hanzi {
            hanzi.fontSize = 50
            hanzi.fontName = "STHeitiSC-Medium"  //"PingFangSC-SemiBold"
            hanzi.verticalAlignmentMode = .center
            hanzi.text = wordValue
        }
        if let tile = self.tile {
            tile.color = .blue
            tile.position = CGPoint(x: 200.0, y: 250.0)
            tile.zPosition = 10.0
            tile.addChild(self.hanzi!)
        }
    }
} */

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
  //  let answerTile: AnswerTile
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var theTarget : SKSpriteNode?
    private var spinnyNode : SKShapeNode?
    private var hanzi : SKLabelNode?
    private var clue : SKLabelNode?
    private var tile : SKSpriteNode?
    private var Tile : SKSpriteNode?
    private var settings : SKLabelNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
   //     answerTile = AnswerTile()
        
        // Add the target
        print("before theTarget")
        self.theTarget = SKSpriteNode()
        if let theTarget = self.theTarget {
            print("theTarget")
            theTarget.texture = SKTexture(imageNamed: "archery_target")
            theTarget.size = theTarget.texture!.size()
            theTarget.size = CGSize(width: 500.0, height: 500.0)
            print (theTarget.size.width)
            theTarget.anchorPoint = CGPoint(x: 0, y: 1)
            theTarget.position = CGPoint(x: -theTarget.size.width/2, y: 500)
            theTarget.zPosition = 5.0
            self.addChild(theTarget)
        }
        
        // Create shape node to use during mouse interaction
     /*   let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        } */
        
        
        // Sample a random key:value pair from the dictionary
        print(Dictionary.count)
        var randomWord = Dictionary.randomElement()!
        print (randomWord)
        
        // Create a LabelNode to display the word below the target
        self.clue = SKLabelNode.init()
        if let clue = self.clue {
            clue.position = CGPoint(x: 0.0, y: -100.0)
            clue.fontSize = 50
            clue.fontName = "STHeitiSC-Medium"
            clue.text = randomWord.key
            clue.zPosition = 80
            self.addChild(clue)
        }
        
        // Create a tile for the candidate answers
        self.Tile = AnswerTile(x: 0.0, y: 250.0, word: randomWord.value)
        self.addChild(self.Tile!)
        
        randomWord = Dictionary.randomElement()!
        let newTile1 = AnswerTile(x: 100.0, y: -200.0, word: randomWord.value)
        self.addChild(newTile1)
        
        randomWord = Dictionary.randomElement()!
        let newTile2 = AnswerTile(x:-100.0, y: -200.0, word: randomWord.value)
        self.addChild(newTile2)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
  /*      if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        } */
    }
    
    func touchMoved(toPoint pos : CGPoint) {
  /*      if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        } */
    }
    
    func touchUp(atPoint pos : CGPoint) {
   /*     if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        } */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        if let myTile = self.Tile {
            myTile.run(SKAction.moveBy(x: 0.0, y: 250.0, duration: 3.0))
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
