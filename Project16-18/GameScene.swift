//
//  GameScene.swift
//  Project16-18
//
//  Created by Eddie Jung on 8/24/21.
//

import SpriteKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var ammoLabel: SKLabelNode!
    var reloadLabel: SKLabelNode!
    
    var possibleTargets = ["stick0", "stick1", "stick2", "target0", "target1", "target2", "target3"]
    var gameTimer: Timer?
    var isGameOver = false
    var gameTime = 60.00
    
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
        woodBackground.name = "background"
        addChild(woodBackground)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.name = "scoreLabel"
        addChild(scoreLabel)
        score = 0
        
        ammoLabel = SKLabelNode(fontNamed: "Chalkduster")
        ammoLabel.position = CGPoint(x: 408, y: 8)
        ammoLabel.horizontalAlignmentMode = .right
        ammoLabel.name = "ammoLabel"
        addChild(ammoLabel)
        ammo = 6
        
        reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
        reloadLabel.text = "Reload"
        reloadLabel.position = CGPoint(x: 908, y: 8)
        reloadLabel.horizontalAlignmentMode = .right
        reloadLabel.name = "reloadLabel"
        addChild(reloadLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(createTarget), userInfo: nil, repeats: true)
    }
    
    @objc func createTarget() {
        gameTime -= 0.4
        
        if gameTime <= 0 {
            isGameOver = true
        }
        
        possibleTargets.shuffle()
        
        for i in 0...2 {
            let sprite = SKSpriteNode(imageNamed: possibleTargets[i])
            if possibleTargets[i].contains("target") {
                sprite.name = "target"
            } else {
                sprite.name = "stick"
            }
            
            sprite.isHidden = false
            
            if i == 1 {
                sprite.position = CGPoint(x:-200, y: 400)
                let move = SKAction.moveBy(x: 1400, y: 0, duration: 1.5)
                sprite.run(move)
                
            } else if i == 2 {
                sprite.position = CGPoint(x: 1200, y: 150)
                let move = SKAction.moveBy(x: -1400, y: 0, duration: 2)
                sprite.run(move)
            } else {
                sprite.position = CGPoint(x: 1200, y: 650)
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
        
        if !isGameOver {
            for node in tappedNodes {
                if ammo >= 1 {
                    if node.name == "target" {
                        node.isHidden = true
                        score += 1
                    } else if node.name == "stick" {
                        node.isHidden = true
                        score -= 1
                    }
                }
                
                if node.name == "reloadLabel" {
                    ammo = 7
                }
            }
            if ammo > 0 {
                ammo -= 1
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 || node.position.x > 1300 {
                node.removeFromParent()
            }
        }
        
        if isGameOver {
            gameTimer?.invalidate()
            let gameOver = SKSpriteNode(imageNamed: "game-over")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
        }
    }
 
}
