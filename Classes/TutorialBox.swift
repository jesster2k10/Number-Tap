//
//  TutorialBox.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

import SpriteKit

class TutorialBox : SKSpriteNode {
    
    var currentTexture = SKTexture()
    var currentType : tutorialTypes!
    var hasAnimationFinished = false
    
    let lineOne = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let lineTwo = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let lineThree = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    
    init(withType type: tutorialTypes, lineOne l1: String, lineTwo l2: String?, lineThree l3: String?, fontSize size: CGFloat) {
        currentTexture = SKTexture(imageNamed: tutorialTypes.Regular.rawValue)
        super.init(texture: currentTexture, color: UIColor.clear, size: currentTexture.size())
        
        currentType = type
        
        if currentType == .BigDown || currentType == .Down {
            zRotation = 180
        }
        
        lineOne.zPosition = 999
        lineTwo.zPosition = 999
        lineThree.zPosition = 999
        
        if l2 == nil && l3 == nil {
            
            lineOne.verticalAlignmentMode = .baseline
            lineOne.horizontalAlignmentMode = .center
            lineOne.text = l1
            lineOne.fontSize = size
            lineOne.fontColor = UIColor.black
            //lineOne.position = CGPointMake(-0.5, 0.947)
            addChild(lineOne)
            
        } else if l2 != nil || l3 != nil{
            
            lineOne.verticalAlignmentMode = .baseline
            lineOne.horizontalAlignmentMode = .center
            lineOne.text = l1
            lineOne.fontSize = 15
            lineOne.fontColor = UIColor.black
            lineOne.position = CGPoint(x: -1.013, y: 17.7)
            addChild(lineOne)
            
            lineTwo.verticalAlignmentMode = .baseline
            lineTwo.horizontalAlignmentMode = .center
            lineTwo.text = l2
            lineTwo.fontSize = 15
            lineTwo.fontColor = UIColor.black
            lineTwo.position = CGPoint(x: -1.013, y: 2.081)
            addChild(lineTwo)
            
            lineThree.verticalAlignmentMode = .baseline
            lineThree.horizontalAlignmentMode = .center
            lineThree.text = l3
            lineThree.fontSize = 15
            lineThree.fontColor = UIColor.black
            lineThree.position = CGPoint(x: -1.013, y: -13.538)
            addChild(lineThree)
            
        } else if l2 != nil && l3 == nil {
            
            lineOne.verticalAlignmentMode = .top
            lineOne.horizontalAlignmentMode = .center
            lineOne.text = l1
            lineOne.fontSize = 15
            lineOne.fontColor = UIColor.black
            lineOne.position = CGPoint(x: -0.771, y: 25.947)
            addChild(lineOne)
            
            lineTwo.verticalAlignmentMode = .baseline
            lineTwo.horizontalAlignmentMode = .center
            lineTwo.text = l2!
            lineTwo.fontSize = 15
            lineTwo.fontColor = UIColor.black
            lineTwo.position = CGPoint(x: -0.771, y: -8.053)
            addChild(lineTwo)
        }
        setScale(0)
    }
    
    func bounce () {
        var scale = SKAction()
        
        if currentType == .BigRegular || currentType == .BigDown {
            scale = SKAction.scale(to: 1.088, duration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
        } else {
            
            scale = SKAction.scale(to: 1, duration: 2, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
        }
        
        run(scale)
    }
    
    func reBounce() {
        let scale = SKAction.scale(to: 0.005, duration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
        run(scale) {
            self.hasAnimationFinished = true
        }
        
        
    }
    
    func isFinished () -> Bool {
        return hasAnimationFinished
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

