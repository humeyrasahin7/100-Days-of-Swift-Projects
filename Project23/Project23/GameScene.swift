//
//  GameScene.swift
//  Project23
//
//  Created by Hümeyra Şahin on 9.11.2021.
//

import SpriteKit
import AVFoundation


// MARK: enums
enum ForceBomb{
    case never, always, random
}

enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain, fastEnemy
}

// MARK: variables
class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
            
        }
    }
    
    var liveImages = [SKSpriteNode]()
    var lives = 3
    
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    
    var activeSlicePoints = [CGPoint]()
   
    var isSwooshSoundActive = false
    var activeEnemies = [SKSpriteNode]()
    var bombsAudioSoundEffect: AVAudioPlayer?
    
    var popupTime = 0.9
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequenceQueued = true
    
    var isFastEnemy = false
    
    var isGameEnded = false
    var gameOver: SKLabelNode!
    
    //MARK: constants
    
    let randomXVelocity1 = Int.random(in: 3...5)
    let randomXVelocity2 = Int.random(in: 8...15)
    let angularVelocityCons = CGFloat.random(in: -3...3)
    let randomYVelocity = Int.random(in: 24...32)
    
    
    
    
    
    // MARK: functions
    
    
    

    // MARK: didMove(to:)
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6) //adds gravitiy to our physics simulation
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0...1000 {
            if let nextSquence = SequenceType.allCases.randomElement() {
                sequence.append(nextSquence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.tossEnemies()
        }
    }
    
    // MARK: createScore
    func createScore(){
        scoreLabel = SKLabelNode()
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 48
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        scoreLabel.position = CGPoint(x: 8, y: 8)
        score = 0
    }
    
    
    // MARK: createLives
    func createLives(){
        for i in 0..<3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            liveImages.append(spriteNode)
        }
        
        
    }
    
    
    // MARK: createSlices
    func createSlices(){
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1)
        activeSliceBG.lineWidth = 9
        
        activeSliceFG.strokeColor = UIColor.white
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    
    // MARK: Touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameEnded {
            return
        }

        guard let touch = touches.first else { return }

        let location = touch.location(in: self)

        activeSlicePoints.append(location)
        redrawActiveSlice()

        if !isSwooshSoundActive {
            playSwooshSound()
        }

        let nodesAtPoint = nodes(at: location)

        for node in nodesAtPoint {
            if node.name == "enemy" {
                // destroy penguin
                // 1
                let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy")!
                emitter.position = node.position
                addChild(emitter)
                
                

                // 2
                node.name = ""

                // 3
                node.physicsBody?.isDynamic = false

                // 4
                let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])

                // 5
                let seq = SKAction.sequence([group, SKAction.removeFromParent()])
                node.run(seq)

                // 6
                if isFastEnemy {
                    score += 10
                } else {
                    score += 1
                }

                // 7
                let index = activeEnemies.index(of: node as! SKSpriteNode)!
                activeEnemies.remove(at: index)

                // 8
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            } else if node.name == "bomb" {
                // destroy bomb
                let emitter = SKEmitterNode(fileNamed: "sliceHitBomb")!
                emitter.position = node.parent!.position
                addChild(emitter)

                node.name = ""
                node.parent?.physicsBody?.isDynamic = false

                let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])

                let seq = SKAction.sequence([group, SKAction.removeFromParent()])

                node.parent?.run(seq)

                let index = activeEnemies.index(of: node.parent as! SKSpriteNode)!
                activeEnemies.remove(at: index)

                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggedByBomb: true)
            }
        }
    }
    // MARK: end game
    func endGame(triggedByBomb: Bool){
        
        guard isGameEnded == false else {return}
        
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombsAudioSoundEffect?.stop()
        bombsAudioSoundEffect = nil
        
        if triggedByBomb {
            liveImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            liveImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            liveImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        gameOver = SKLabelNode()
        gameOver.fontName = "Chalkduster"
        gameOver.fontSize = 50
        gameOver.horizontalAlignmentMode = .center
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.text = "Game Over"
        addChild(gameOver)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        
        activeSliceBG.removeAllActions()
        activeSliceFG.removeAllActions()
        
        activeSliceBG.alpha = 1
        activeSliceFG.alpha = 1
        
    }
    
    // MARK: redrawActiveSlice
    func redrawActiveSlice(){
        if activeSlicePoints.count < 2 {
            activeSliceBG.path = nil
            activeSliceFG.path = nil
            return
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count{
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceBG.path = path.cgPath
        activeSliceFG.path = path.cgPath
        
        
    }
    
    // MARK: playSwoosh Sound
    
    func playSwooshSound(){
        isSwooshSoundActive = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        
        run(swooshSound) { [weak self] in
            self?.isSwooshSoundActive = false
        }
    }
    
    // MARK: createEnemy
    func createEnemy(forceBomb: ForceBomb = .random){
        let enemy: SKSpriteNode
        
        var enemyType = Int.random(in: 0...8)
        
        if forceBomb == .never{
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        }
        
        if enemyType == 0 {
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            if bombsAudioSoundEffect != nil {
                bombsAudioSoundEffect?.stop()
                bombsAudioSoundEffect = nil
            }
            
            
            if let path = Bundle.main.url(forResource: "sliceFuse", withExtension: "caf"){
                if let sound = try? AVAudioPlayer(contentsOf: path){
                    bombsAudioSoundEffect = sound
                    sound.play()
                }
            }
            
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse"){
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
            
        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
        }
        
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition
        
        
        let randomXVelocity: Int
        
        if randomPosition.x < 256{
            randomXVelocity = randomXVelocity2
        } else if randomPosition.x < 512{
            randomXVelocity = randomXVelocity1
        } else if randomPosition.x < 768 {
            randomXVelocity = -randomXVelocity1 // moves to the left
        } else {
            randomXVelocity = -randomXVelocity2
        }
        
        let randomYVelocity = randomYVelocity
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = angularVelocityCons
        enemy.physicsBody?.categoryBitMask = 0
        
        addChild(enemy)
        activeEnemies.append(enemy)
        
        
    }
    //MARK: substract life
    
    func substractLife(){
        lives -= 1
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        
        var life: SKSpriteNode
        
        if lives == 2{
            life = liveImages[0]
        } else if lives == 1 {
            life = liveImages [1]
        } else {
            life = liveImages[0]
            endGame(triggedByBomb: false)
        }
         
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
        
        
    }
    
    
    
    // MARK: update
    override func update(_ currentTime: TimeInterval) {
        
        if activeEnemies.count > 0{
            for (index, node) in activeEnemies.enumerated().reversed(){
                if node.position.y < -140 {
                    node.removeAllActions()
                    
                    if node.name == "enemy" {
                        
                        node.name = ""
                        substractLife()
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                        
                    } else if node.name == "bombContainer" {
                        
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                }
            }
        } else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime){ [weak self] in
                    self?.tossEnemies()
                    
                }
                
                nextSequenceQueued = true
            }
        }
        
        var bombCount = 0

        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCount += 1
                break
            }
        }

        if bombCount == 0 {
            // no bombs – stop the fuse sound!
            bombsAudioSoundEffect?.stop()
            bombsAudioSoundEffect = nil
        }
    }
    
    // MARK: tossEnemies
    
    func tossEnemies() {
        
        guard isGameEnded == false else {return}
        
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02

        let sequenceType = sequence[sequencePosition]

        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)

        case .one:
            createEnemy()

        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)

        case .two:
            createEnemy()
            createEnemy()

        case .three:
            createEnemy()
            createEnemy()
            createEnemy()

        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()

        case .chain:
            createEnemy()

            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in self?.createEnemy() }

        case .fastChain:
            createEnemy()

            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy() }
        case .fastEnemy:
            isFastEnemy = true
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 15.0)) {[weak self] in self?.createEnemy()}
            print("faster created")
        }

        sequencePosition += 1
        nextSequenceQueued = false
    }
}
