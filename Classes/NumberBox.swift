//
//  NumberBox.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

import SpriteKit

extension Array {
    func contain<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

enum boxStates : UInt32 {
    case normal = 0
    case used = 1
    case update = 2
}

enum tutorialTypes : String {
    case Regular = "tutorialBig"
    case BigRegular = "bigRegular"
    case Down = "tutorialDown"
    case BigDown = "bigDown"
}

@objc class NumberBox: SKSpriteNode {
    var currentTexture : SKTexture?
    
    let normText: SKTexture = SKTexture(imageNamed: "numberNormal")
    let usedText: SKTexture = SKTexture(imageNamed: "numberGreyedOut")
    
    var array = [Int]()
    var indexs = 0
    var index = 0
    
    internal var usedBox : Bool = false
    
    internal var currentState : boxStates = .normal
    
    var number = SKLabelNode(fontNamed: "Montserrat-Bold")
    var numberShadow = SKLabelNode(fontNamed: "Montserrat-Bold")
    var numberInt = 0
    
    var timer = NSTimer()
    
    init(texture : SKTexture?, color: UIColor, size: CGSize, index: Int?) {
        currentTexture = normText
        super.init(texture: currentTexture, color: color, size: size)
        
        self.size = (currentTexture?.size())!
        self.setScale(0)
        
        let random = arc4random_uniform(2)+1
        
        if random == 3 {
            self.zRotation = 0.75
        }
        
        number.text = "\(indexs)"
        number.fontColor = UIColor.whiteColor()
        number.zPosition = 2
        number.fontSize = 30
        number.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        number.horizontalAlignmentMode = .Center
        number.verticalAlignmentMode = .Center
        self.addChild(number)
        
        numberShadow.text = "\(indexs)"
        numberShadow.fontColor = UIColor(rgba: "#d24536")
        numberShadow.zPosition = 1
        numberShadow.fontSize = 30
        numberShadow.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-5)
        numberShadow.horizontalAlignmentMode = .Center
        numberShadow.verticalAlignmentMode = .Center
        self.addChild(numberShadow)
        
        timer = NSTimer.every(0.1, {
            self.update()
        })
        
    }
    
    func isCurrentState() -> boxStates {
        return currentState
    }
    
    @objc func switchStates () {
        switch currentState {
        case .normal:
            currentTexture = normText
            texture = currentTexture
            break;
        case .update:
            if indexs > 0 {
                number.text = "\(indexs)"
                numberShadow.text = "\(indexs)"
                timer.invalidate()
            }
            
            let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI * 2), duration: 1)
            self.runAction(rotateAction)
            
            break;
        case .used:
            let scaleSequence = SKAction.sequence([SKAction.scaleTo(0.9, duration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0), SKAction.scaleTo(1, duration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)])
            self.runAction(scaleSequence)
            currentTexture = usedText
            self.texture = currentTexture
            
        }
    }
    
    @objc func flip () {
        
        let liftUp = SKAction.scaleTo(1.2, duration: 0.2)
        let dropDown = SKAction.scaleTo(1.0, duration: 0.2)
        
        let touchAction = SKAction.sequence([liftUp, dropDown])
        
        let flip = SKAction.scaleXTo(-1, duration: 0.4)
        
        self.setScale(1.0)
        
        let changeColor = SKAction.runBlock( { self.number.alpha = 0; self.numberShadow.alpha = 0})
        let action = SKAction.sequence([flip, changeColor] )
        
        let finishedAction = SKAction.group([touchAction, action])
        
        self.runAction(finishedAction)
    }
    
    @objc func reFlip () {
        let liftUp = SKAction.scaleTo(1.2, duration: 0.2)
        let dropDown = SKAction.scaleTo(1.0, duration: 0.2)
        
        let touchAction = SKAction.sequence([liftUp, dropDown])
        
        let flip = SKAction.scaleXTo(-1, duration: 0.4)
        
        self.setScale(1.0)
        
        let changeColor = SKAction.runBlock( { self.number.alpha = 1; self.numberShadow.alpha = 1})
        let action = SKAction.sequence([flip, changeColor] )
        
        let finishedAction = SKAction.group([touchAction, action])
        
        self.runAction(finishedAction)
        
    }
    
    @objc func normal () {
        usedBox = false
        currentState = .normal
        switchStates()
    }
    
    @objc func update () {
        currentState = .update
        switchStates()
    }
    
    @objc func used () {
        usedBox = true
        currentState = .used
        switchStates()
    }
    
    @objc func darken () {
        let scaleSequence = SKAction.sequence([SKAction.scaleTo(0.95, duration: 0.1), SKAction.scaleTo(1, duration: 0.1)])
        self.runAction(scaleSequence)
        currentTexture = SKTexture(imageNamed: "numberGreyedOut")
        self.texture = currentTexture
    }
    
    @objc func scale () {
        self.runAction(SKAction.scaleTo(1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
    }
    
    @objc func scaleToSmallerSize () {
        self.runAction(SKAction.scaleTo(0.6, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
    }
    
    
    @objc func reScale (withCompletion completion: () -> ()) {
        self.runAction(SKAction.scaleTo(0, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)) {
            completion()
        }
    }
    
    @objc func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
        var numbers: [Int] = []
        return {
            if numbers.count == 0 {
                numbers = Array(min ... max)
            }
            
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.removeAtIndex(index)
        }
    }
    
    func randomWord() {
        
        let getRandom = randomSequenceGenerator(1, max: 99)
        for _ in 1...24 {
            array.append(getRandom());
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        currentTexture = nil
        
        timer.invalidate()
        
        self.removeAllActions()
    }
}