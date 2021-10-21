//
//  WhackSlote.swift
//  Project14
//
//  Created by Hümeyra Şahin on 21.10.2021.
//

import UIKit
import SpriteKit

class WhackSlote: SKNode {
    
    var charNode: SKSpriteNode!
    var mud: SKEmitterNode!
    var isVisible = false
    var isHit = false
    
    

    func configure(at position: CGPoint){
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "characer"
        
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double){
        if isVisible {return}
        
        charNode.yScale = 1
        charNode.xScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
       
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)){
            [weak self] in
            self?.hide()
        }
        
        
    }
    
    func hide(){
        if !isVisible {return}
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
        showMud(at: charNode.position)
    }
    
    func hit(){
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in self?.isVisible = false }
        let sequance = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequance)
        
        
    }
    func showMud(at position: CGPoint){
        mud = SKEmitterNode(fileNamed: "MudParticle.sks")
        mud.position = position
        addChild(mud)
    }
}
