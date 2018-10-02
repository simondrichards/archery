//
//  AnswerTile.swift
//  archery
//
//  Class for the tiles which display the characters moving on the target
//
//  Created by Simon Richards on 01/10/2018.
//  Copyright © 2018 Simon Richards. All rights reserved.
//

import SpriteKit

class AnswerTile: SKSpriteNode {
    
    var hanzi : SKLabelNode?
    var word: String
    
    // MARK: - Init
    
    init(x: CGFloat, y: CGFloat, word: String) {
        let tileSize = CGSize(width: 30, height: 30)
        self.word = word

        super.init(texture: nil, color: .blue, size: tileSize)
        self.position.x = x
        self.position.y = y
        self.zPosition = 10.0 // This should be in front of the target
        setup()
    }
    
    func setup() {
        // Setup for a tile
    
        let textSize: Int = 50
        var tileSize: Int
    
        // Make tile big enough for two characters
        tileSize = 3*textSize + 8
        self.size.width = CGFloat(tileSize)
        self.size.height = CGFloat(textSize)
        
        self.hanzi = SKLabelNode.init()
        if let hanzi = self.hanzi {
            hanzi.fontSize = 50
            hanzi.fontName = "STHeitiSC-Medium"
            hanzi.verticalAlignmentMode = .center
            hanzi.text = self.word
        }
        addChild(self.hanzi!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
