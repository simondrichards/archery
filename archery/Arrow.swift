//
//  Arrow.swift
//  archery
//
//  Class for arrows representing number of lives remaining
//
//  Created by Simon Richards on 03/10/2018.
//  Copyright © 2018 Simon Richards. All rights reserved.
//

import SpriteKit

class Arrow: SKSpriteNode {

    // MARK: - Init
    
    init(x: CGFloat, y: CGFloat) {
        let tileSize = CGSize(width: 30, height: 30)
        
        super.init(texture: nil, color: .white, size: tileSize)
        self.texture = SKTexture(imageNamed: "Arrow")
        self.size = self.texture!.size()
        self.setScale(0.3)
        self.position.x = x
        self.position.y = y
        self.zPosition = 10.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
