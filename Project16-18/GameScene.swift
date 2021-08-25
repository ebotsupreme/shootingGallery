//
//  GameScene.swift
//  Project16-18
//
//  Created by Eddie Jung on 8/24/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var ammoLabel: SKLabelNode!
    var player: SKSpriteNode!
    
    var possibleTargets = ["stick0", "stick1", "stick2", "target0", "target1", "target2", "target3"]
    var gameTimer: Timer?
    var isGameOver = false
    var gameTime = 60
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var ammo = 6 {
        didSet {
            ammoLabel.text = "Ammo: \(ammo)"
        }
    }
    
    override func didMove(to view: SKView) {
        let woodBackground = SKSpriteNode(imageNamed: "whackBackground")
        woodBackground.position = CGPoint(x: 512, y: 384)
        woodBackground.blendMode = .replace
        woodBackground.zPosition = -1
        addChild(woodBackground)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        ammoLabel = SKLabelNode(fontNamed: "Chalkduster")
        ammoLabel.text = "Ammo: 6"
        ammoLabel.position = CGPoint(x: 408, y: 8)
        ammoLabel.horizontalAlignmentMode = .right
        addChild(ammoLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
    }
    
    @objc func createTarget() {
        possibleTargets.shuffle()
        
        for i in 0...2 {
            let sprite = SKSpriteNode(imageNamed: possibleTargets[i])
            if possibleTargets[i].contains("target") {
                sprite.name = "target"
            } else {
                sprite.name = "stick"
            }
            
            if i == 1 {
                sprite.position = CGPoint(x:-200, y: 400)
                let move = SKAction.moveBy(x: 1400, y: 0, duration: 4)
                sprite.run(move)
                
            } else if i == 2 {
                sprite.position = CGPoint(x: 1200, y: 100)
                let move = SKAction.moveBy(x: -1400, y: 0, duration: 2)
                sprite.run(move)
            } else {
                sprite.position = CGPoint(x: 1200, y: 700)
                let move = SKAction.moveBy(x: -1400, y: 0, duration: 3)
                sprite.run(move)
            }
            
            
            addChild(sprite)
        }
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node.name == "target" {
                print("HIT!")
            } else if node.name == "stick" {
                print("MISS!")
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
 
}
