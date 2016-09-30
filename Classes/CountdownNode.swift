//
//  CountdownNode.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

import SpriteKit

class CountdownNode: SKSpriteNode {
    
    var counter = 3
    var counterTimer = Timer()
    let counterText = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: 0, height: 0))
        
        let counterBG = SKSpriteNode(imageNamed: "counter")
        counterBG.position = CGPoint(x: frame.midX, y: frame.midY)
        counterBG.alpha = 1
        counterBG.zPosition = 1
        counterBG.setScale(1.5)
        addChild(counterBG)
        
        counterText.text = String(counter)
        counterText.verticalAlignmentMode = .center
        counterText.horizontalAlignmentMode = .center
        counterText.fontColor = UIColor.white
        counterText.fontSize = 100
        counterText.zPosition = 20
        addChild(counterText)
        
        UserDefaults.standard.set(counter, forKey: k.NotificationCenter.Counter)
    }
    
    func counterUpdate () {
        FTLogging().FTLog("update by -1")
        
        if counter != 0 {
            counter -= 1
            if counter != 0 {counterText.text = "\(counter)"}
        } else {
            counterText.text = NSLocalizedString("go-countdown", comment: "go")
            counterTimer.invalidate()
            NotificationCenter.default.post(name: Notification.Name(rawValue: k.NotificationCenter.Counter), object: nil, userInfo: ["counter" : counter])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
