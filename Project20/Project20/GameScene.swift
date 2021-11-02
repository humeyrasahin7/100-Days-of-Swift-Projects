//
//  GameScene.swift
//  Project20
//
//  Created by Hümeyra Şahin on 1.11.2021.
//

import SpriteKit


class GameScene: SKScene {
    
    var gameTimer: Timer?
    var fireworks = [SKNode]()
    
    let leftEgde = -22
    let bottomEdge = -22
    let rightEgde = 1024 + 22
    
   
    var scoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var counter = 0
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "chalkDuster")
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 25
        scoreLabel.position = CGPoint(x: 200, y: 40)
        scoreLabel.zPosition = 1
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        
       
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
       
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int){
        
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)
        
        switch Int.random(in: 0...2){
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        if let emitter = SKEmitterNode(fileNamed: "fuse.sks"){
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }
        
        fireworks.append(node)
        addChild(node)
    }
    
    //challenge 2
    func gameOver(){
        gameTimer?.invalidate()
        gameOverLabel = SKLabelNode(fontNamed: "chalkDuster")
        gameOverLabel.text = "Game Over"
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.zPosition = 1
        scoreLabel.position = CGPoint(x: 512, y: 334)
        scoreLabel.horizontalAlignmentMode = .center
        addChild(gameOverLabel)
        
    }
    
    @objc func launchFireworks(){
        let movementAmount: CGFloat = 1800
        counter += 1
        
        if counter == 3 {
            gameOver()
        } else {
        
        switch Int.random(in: 0...3) {
        case 0:
            
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
            
        case 1:
            
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
        
        case 2:
            
            createFirework(xMovement: movementAmount, x: leftEgde, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEgde, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEgde, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEgde, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEgde, y: bottomEdge)

        case 3:
            
            createFirework(xMovement: -movementAmount, x: rightEgde, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEgde, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEgde, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEgde, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEgde, y: bottomEdge)

        default:
            break
        }
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            
            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { return }
                
                if firework.name == "selected" && firework.color != node.color{
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }
            node.name = "selected"
            node.colorBlendFactor = 0

        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    
    func explode(firework: SKNode){
        if let emitter = SKEmitterNode(fileNamed: "explode.sks"){
            emitter.position = firework.position
            addChild(emitter)
            
            // challenge 3
            let waitAction = SKAction.wait(forDuration: 2)
            let removeAction = SKAction.run { emitter.removeFromParent() }
            let sequence = SKAction.sequence([waitAction, removeAction])
            emitter.run(sequence)
        }
        firework.removeFromParent()
    }
    
    func explodeFireworks(){
        var numExploded = 0
        
        for(index, fireworkcontainer) in fireworks.enumerated().reversed() {
            
            guard let firework = fireworkcontainer.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected"{
                explode(firework: fireworkcontainer)
                fireworks.remove(at: index)
                numExploded += 1
                
            }
        }
        
        switch numExploded{
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2000
        default:
            score += 4000
            
        }
        
        
        
    }
}
