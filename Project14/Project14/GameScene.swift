//
//  GameScene.swift
//  Project14
//
//  Created by Hümeyra Şahin on 21.10.2021.
//

import SpriteKit


class GameScene: SKScene {
    
    var gameScore: SKLabelNode!
    var finalScore: SKLabelNode!
    var smoke: SKEmitterNode!
    var slots = [WhackSlote]()
    var popUpTime = 0.85
    var score = 0 {
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }
    var numRounds = 0
    
    
    
    override func didMove(to view: SKView) {
        let bg = SKSpriteNode(imageNamed: "whackBackground")
        bg.position = CGPoint(x: 512, y: 384)
        bg.blendMode = .replace
        bg.zPosition = -1
        addChild(bg)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 {createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))}
        for i in 0..<4 {createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))}
        for i in 0..<5 {createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))}
        for i in 0..<4 {createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
            }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlote else { continue }
            if !whackSlot.isVisible {continue} //ortak
            if whackSlot.isHit {continue} //ortak
            whackSlot.hit() //ortak
            smoke = SKEmitterNode(fileNamed: "SmokeParticle.sks")
            smoke.position = location
            addChild(smoke)
            
            if node.name == "charFriend" {
               
                
                score -= 5
                
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                
            } else if node.name == "charEnemy" {
                
               //ortak kodları dışarıya aldık
                
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
        
        
    }
    
    func createSlot(at position: CGPoint){
        let slot = WhackSlote()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
        
    }
    
    func createEnemy(){
        numRounds += 1
        if numRounds >= 10 {
            for slot in slots {
                slot.hide()
            }
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 521, y: 384)
            gameOver.zPosition = 1
            run(SKAction.playSoundFileNamed("gameOver.caf", waitForCompletion: false))
            addChild(gameOver)
            
            finalScore = SKLabelNode(fontNamed: "Chalkduster")
            finalScore.fontSize = 40
            finalScore.zPosition = 1
            finalScore.position = CGPoint(x: 521, y: 300)
            finalScore.text = "Final Score: \(score)"
            addChild(finalScore)
            
            return //stop calling create enemy
        }
        
        popUpTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popUpTime)
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popUpTime) }
        if Int.random(in: 0...12) > 8 {  slots[2].show(hideTime: popUpTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popUpTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popUpTime)  }

        let minDelay = popUpTime / 2.0
        let maxDelay = popUpTime * 2
        let delay = Double.random(in: minDelay...maxDelay)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
            }
    }
    
   
}
