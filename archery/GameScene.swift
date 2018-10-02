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
    private var theTarget : SKSpriteNode?
    private var hanzi : SKLabelNode?
    private var clue : SKLabelNode?
    private var Tile : SKSpriteNode?
    
    // Create an empty array of tiles
    var theTiles = [AnswerTile]()
    
    let numberOfOptions = 4
    var initialPosition = [CGPoint]()
    var finalPosition   = [CGPoint]()
    var correct = 0
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    var lives = 3
    
    

    func initial(){
        // Set up initial positions
        switch numberOfOptions {
            case 4:
                initialPosition.append(CGPoint(x:-90.0, y: 40.0))
                initialPosition.append(CGPoint(x: 90.0, y: 40.0))
                initialPosition.append(CGPoint(x:-90.0, y:-40.0))
                initialPosition.append(CGPoint(x: 90.0, y:-40.0))
                
                finalPosition.append(CGPoint(x: -300.0, y: 300.0))
                finalPosition.append(CGPoint(x:  300.0, y: 300.0))
                finalPosition.append(CGPoint(x: -300.0, y:-300.0))
                finalPosition.append(CGPoint(x:  300.0, y:-300.0))


            default:
                break
        }
    }
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Add the target

        self.theTarget = SKSpriteNode()
        if let theTarget = self.theTarget {
            theTarget.texture = SKTexture(imageNamed: "archery_target")
            theTarget.size = theTarget.texture!.size()
            theTarget.size = CGSize(width: self.size.width, height: self.size.width)
            print (theTarget.size.width)
            theTarget.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            theTarget.position = CGPoint(x: 0.0, y: 0.0)
            theTarget.zPosition = 5.0
            self.addChild(theTarget)
        }
        
        // Display the score
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 50
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x:0.0, y: 600.0)
        addChild(scoreLabel)
        
       // Sample a random key:value pair from the dictionary
        var randomWord = Dictionary.randomElement()!
        print (randomWord)

   
        
        // Create a tile for the candidate answers
 /*       self.Tile = AnswerTile(x: 0.0, y: 250.0, word: randomWord.value)
        self.addChild(self.Tile!)
        
        randomWord = Dictionary.randomElement()!
        let newTile1 = AnswerTile(x: 100.0, y: -200.0, word: randomWord.value)
        self.addChild(newTile1)
        
        randomWord = Dictionary.randomElement()!
        let newTile2 = AnswerTile(x:-100.0, y: -200.0, word: randomWord.value)
        self.addChild(newTile2)
     */

        
        // Create the required number of tiles
        initial() // Set initial positions
        var wordSet = [String: String]()
        for i in 0..<numberOfOptions{
            
            // Get a random word from the dictionary
            randomWord = Dictionary.randomElement()!
            
            // Discard and resample if we've already created a tile for this word
            if (i>0) {
                while (wordSet[randomWord.key] != nil){
                    randomWord = Dictionary.randomElement()!
                }
            }
            
            print(initialPosition.count)
            print(initialPosition[i])
            theTiles.append(AnswerTile(x: initialPosition[i].x, y: initialPosition[i].y, key: randomWord.key, word: randomWord.value))
            self.addChild(theTiles[i])
            wordSet[randomWord.key] = randomWord.value
        }
        // Pick the correct answer randomly from the set of sampled words
        correct = Int.random(in: 0..<numberOfOptions)
        print ("Correct answer = \(theTiles[correct].word) , \(theTiles[correct].key)")
        
        // Create a LabelNode to display the word below the target
        self.clue = SKLabelNode.init()
        if let clue = self.clue {
            clue.position = CGPoint(x: 0.0, y: -600.0)
            clue.fontSize = 50
            clue.fontName = "STHeitiSC-Medium"
            clue.text = theTiles[correct].key
            clue.zPosition = 80
            self.addChild(clue)
        }
        
        for i in 0..<numberOfOptions {
            let moveToEdge:SKAction = SKAction.move(to: finalPosition[i], duration: 3.0)
            let fadeAway:SKAction = SKAction.fadeOut(withDuration: 1.0)
            let seq:SKAction = SKAction.sequence([moveToEdge, fadeAway])
            theTiles[i].run(seq)
        }
    }
    
    func calculateSector(position: CGPoint) -> Int {
        // Calculate which sector of the target the touch point is in
        var sector = 0
        
        let x = position.x
        let y = position.y
        
        switch numberOfOptions {
        case 4:
            if (x<0 && y>=0)       {sector=1}
            else if (x>=0 && y>=0) {sector=2}
            else if (x>=0 && y<0)  {sector=3}
            else if (x<0 && y<0)   {sector=4}
        default:
            sector = 0
        }
        
        return(sector)
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
 
        if let touch = touches.first {
            
            for i in (0..<numberOfOptions){
                theTiles[i].removeAllActions()
            }
            
            let location = touch.location(in: self)
            print("Touch location = \(location)")
            let sector = calculateSector(position: location)
            print ("Selected sector = \(sector)")
            
            if (sector-1 == correct) {
                print ("Correct")
                score += 1
            }
            else{
                print ("Incorrect")
                lives -= 1
            }
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
