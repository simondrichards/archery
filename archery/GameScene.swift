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
    private var arrow : SKSpriteNode?
    private var arrow1 : Arrow?
    private var hanzi : SKLabelNode?
    private var clue : SKLabelNode?
    private var Tile : SKSpriteNode?
    
    var newWord: Bool = false
    var attemptMade: Bool = false
    var gameOver: Bool = false
    
    // Create an empty array of tiles
    var theTiles = [AnswerTile]()
    
    // Create an empty array of arrows (lives)
    var theArrows = [Arrow]()
    
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
    
    var livesLabel: SKLabelNode!
    var lives = 3 {
        didSet {
            livesLabel.text = "Lives: \(lives)"
        }
    }

    // MARK- Actions
    let fadeIn:SKAction = SKAction.fadeIn(withDuration: 0.0)
    let fadeAway:SKAction = SKAction.fadeOut(withDuration: 1.0)
    let waitFor2:SKAction = SKAction.wait(forDuration: 2.0)

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
        scoreLabel = SKLabelNode(fontNamed: "STHeitiSC-Medium")
        scoreLabel.fontSize = 50
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x:0.0, y: 550.0)
        addChild(scoreLabel)
        
        // Display lives
        livesLabel = SKLabelNode(fontNamed: "STHeitiSC-Medium")
        livesLabel.fontSize = 50
        livesLabel.text = "Lives: \(lives)"
        livesLabel.position = CGPoint(x:0.0, y: 500.0)
        addChild(livesLabel)
        
        for i in 0..<lives {
            theArrows.append(Arrow(x: CGFloat(-200.0), y: CGFloat(-550.0-30.0*Double(i))))
            self.addChild(theArrows[i])
        }
        
        
       // Sample a random key:value pair from the dictionary
        var randomWord = Dictionary.randomElement()!
        print (randomWord)

        
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
        
        // Create a LabelNode to display the word below the target
        self.clue = SKLabelNode.init()
        if let clue = self.clue {
            clue.position = CGPoint(x: 0.0, y: -500.0)
            clue.fontSize = 50
            clue.fontName = "STHeitiSC-Medium"
            clue.text = theTiles[correct].key
            clue.zPosition = 80
            self.addChild(clue)
        }
        
        
        for i in 0..<numberOfOptions {
            let moveToEdge:SKAction = SKAction.move(to: finalPosition[i], duration: 3.0)
            let seq:SKAction = SKAction.sequence([moveToEdge, waitFor2, fadeAway])
            theTiles[i].run(seq, completion: {() -> Void in
                if i==0 {
                    self.lives -= 1
                    self.theArrows[self.lives].run(self.fadeAway)
                    self.newWord = true
                }
            })
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
            else if (x<0 && y<0)   {sector=3}
            else if (x>=0 && y<0)  {sector=4}
        default:
            sector = 0
        }
        
        return(sector)
    }
    
    func resetTiles() {
        // Reset the tiles to their starting positions and sample new words.
        
        if !self.newWord {
            return
        }
        
        // Create the required number of tiles
        var wordSet = [String: String]()
        for i in 0..<numberOfOptions{
            
            // Get a random word from the dictionary
            var randomWord = Dictionary.randomElement()!
            
            // Discard and resample if we've already created a tile for this word
            if (i>0) {
                while (wordSet[randomWord.key] != nil){
                    randomWord = Dictionary.randomElement()!
                }
            }
            
            theTiles[i].position.x = initialPosition[i].x
            theTiles[i].position.y = initialPosition[i].y
            theTiles[i].color = .blue
            theTiles[i].hanzi!.text = randomWord.value
            theTiles[i].key = randomWord.key
            theTiles[i].word = randomWord.value
            
            theTiles[i].run(fadeIn)

            wordSet[randomWord.key] = randomWord.value
        }
        
        // Pick the correct answer randomly from the set of sampled words
        correct = Int.random(in: 0..<numberOfOptions)
        self.clue!.text = theTiles[correct].key
        
        for i in 0..<numberOfOptions {
            let moveToEdge:SKAction = SKAction.move(to: finalPosition[i], duration: 3.0)
            let seq:SKAction = SKAction.sequence([moveToEdge, waitFor2, fadeAway])
            theTiles[i].run(seq, completion: {() -> Void in
                if i==0 {
                    self.lives -= 1
                    self.gameOver = self.lives < 1
                    self.theArrows[self.lives].run(self.fadeAway)
                    self.newWord = true
                }
            })
        }
        
        // Set the newWord flag false until another word is needed.
        self.newWord = false
    }
    
    func displayOutcome() {
        if !attemptMade {
            return
        }
        for i in 0..<numberOfOptions {
            theTiles[i].run(waitFor2, completion: {() -> Void in
                self.newWord = true
            })
        }
        attemptMade = false
    }
    
    func endGame() {
        if !gameOver {
            return
        }
        print("Game Over")
        newWord = false
    }
    
    func calculateScore(position: CGPoint) -> Int{
        // Calculate the score based on distance from the centre of the target
        var points = 0
        
        let x = position.x
        let y = position.y
        
        // Normalised radius (between 0 and 1)
        let radius = sqrt(x*x + y*y) / (self.size.width/2)
        
        if radius<0.2      {points=9}
        else if radius<0.4 {points=7}
        else if radius<0.6 {points=5}
        else if radius<0.8 {points=3}
        else if radius<1.0 {points=1}
        else               {points=0}
        
        return points
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
        let fadeAway:SKAction = SKAction.fadeOut(withDuration: 1.0)

        if gameOver {
            return
        }
        
        if let touch = touches.first {
            
            for i in (0..<numberOfOptions){
                theTiles[i].removeAllActions()
            }
            
            let location = touch.location(in: self)
            let sector = calculateSector(position: location)
            
            if (sector-1 == correct) {
                theTiles[sector-1].color = .green
                let points = calculateScore(position: theTiles[correct].position)
                score += points
            }
            else{
                theTiles[sector-1].color = .red
                theTiles[correct].color = .green
                let seq:SKAction = SKAction.sequence([waitFor2, fadeAway])
                theArrows[lives-1].run(seq)
                lives -= 1
                gameOver = lives<1
            }
            attemptMade = true
            
            for i in 0..<numberOfOptions {
                theTiles[i].run(waitFor2)
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
        
        endGame()
        displayOutcome()
        resetTiles()
        
        print ("currentTime = \(currentTime)   self.newWord = \(self.newWord)")
        self.lastUpdateTime = currentTime
    }
    override func didEvaluateActions() {
        print ("didEvaluateActions")
    }
}
