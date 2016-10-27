//
//  GameScene.swift
//  Number Tap Mac OS
//
//  Created by Jesse on 27/10/2016.
//  Copyright © 2016 Full Stop Apps. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "background")
    let play = SKSpriteNode(imageNamed: "play")
    let numberTap = SKSpriteNode(imageNamed: "number tap")
    let favourite = SKSpriteNode(imageNamed: "favourite")
    let like = SKSpriteNode(imageNamed: "like")
    let leaderboard = SKSpriteNode(imageNamed: "leaderboard")
    let removeAds = SKSpriteNode(imageNamed: "removeAdsLong")
    let gameMode = SKSpriteNode(imageNamed: "banner")
    let starOne = SKSpriteNode(imageNamed: "star")
    let starTwo = SKSpriteNode(imageNamed: "star")
    var sound = SKSpriteNode(imageNamed: "sound")
    let info = SKSpriteNode(imageNamed: "info")
    let settings = SKSpriteNode(imageNamed: "settings")
    
    //MARK : Settings
    let settingsText = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let help  = SKSpriteNode(imageNamed: "how-to-play")
    let restorePurchases = SKSpriteNode(imageNamed: "restorePurchases")
    let soundOnTexture = SKTexture(imageNamed: "sound-on")
    let soundOfTexture = SKTexture(imageNamed: "sound-off")
    let soundSettings = SKSpriteNode()
    let exit = SKSpriteNode(imageNamed: "exit")
    var settingsArray = [SKNode]()
    var actionsArray = [SKAction]()
    var isShowingSettings = false
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        setupScene()
    }
    
    func setupScene() {
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.zPosition = -10
        background.size = self.size
        addChild(background)
        
        numberTap.position = CGPoint(x: self.frame.midX, y: 739) //324 322
        numberTap.zPosition = 2
        addChild(numberTap)
        
        info.position = CGPoint(x: 450, y: numberTap.position.y + 50)
        info.zPosition = 2
        addChild(info)
        
        sound.position = CGPoint(x: info.position.x - 50, y: info.position.y)
        sound.zPosition = 2
        addChild(sound)
        
        play.position = CGPoint(x: numberTap.position.x, y: 335)
        play.zPosition = 2
        addChild(play)
        
        favourite.position = CGPoint(x: 190, y: numberTap.position.y - 100)
        favourite.zPosition = 2
        addChild(favourite)
        
        leaderboard.position = CGPoint(x: favourite.position.x + 90, y: favourite.position.y)
        leaderboard.zPosition = 2
        addChild(leaderboard)
        
        like.position = CGPoint(x: leaderboard.position.x + 90, y: leaderboard.position.y)
        like.zPosition = 2
        addChild(like)
        
        settings.position = CGPoint(x: like.position.x + 90, y: like.position.y)
        settings.zPosition = 2
        addChild(settings)
        
        removeAds.position = CGPoint(x: numberTap.position.x, y: leaderboard.position.y - 100)
        removeAds.zPosition = 2
        let def = UserDefaults.standard
        if let _ = def.object(forKey: "hasRemovedAds") as? Bool { print("all ads are gone") } else { addChild(removeAds) }
        
        gameMode.position = CGPoint(x: play.position.x, y: play.position.y - 200)
        gameMode.zPosition = 2
        addChild(gameMode)
        
        starOne.position = CGPoint(x: gameMode.position.x - 150, y: gameMode.position.y)
        starOne.zPosition = 5
        addChild(starOne)
        
        starTwo.position = CGPoint(x: gameMode.position.x + 150, y: gameMode.position.y)
        starTwo.zPosition = 5
        addChild(starTwo)
        
        for child in children {
            child.setScale(0)
        }
        
        let increaseAction = SKAction.scale(to: 1.1, duration: 0.5)
        let decreaseAction = SKAction.scale(to: 1, duration: 0.5)
        let completeAction = SKAction.sequence([increaseAction, decreaseAction])
        let completeActions = SKAction.repeatForever(completeAction)
        
        let increaseActionAds = SKAction.scale(to: 0.4, duration: 0.5)
        let decreaseActionAds = SKAction.scale(to: 0.3, duration: 0.5)
        let completeActionAds = SKAction.sequence([increaseActionAds, decreaseActionAds])
        let completeActionsAds = SKAction.repeatForever(completeActionAds)
        
        let rotateAction = SKAction.rotate(byAngle: CGFloat(M_PI*2), duration: 4)
        let rotateRepeat = SKAction.repeatForever(rotateAction)
        
        let rotateAction2 = SKAction.rotate(byAngle: CGFloat(-M_PI*2), duration: 4)
        let rotateRepeat2 = SKAction.repeatForever(rotateAction2)
        
        let completeRepeatAction = SKAction.group([completeActions, rotateRepeat])
        
        starOne.run(rotateRepeat)
        starTwo.run(rotateRepeat2)
        
        let rotateAction1 = SKAction.rotate(byAngle: CGFloat(-M_PI*2), duration: 4)
        let rotateRepeat1 = SKAction.repeatForever(rotateAction1)
        let completeRepeatAction1 = SKAction.group([completeActions, rotateRepeat1])
        
        favourite.run(completeRepeatAction)
        leaderboard.run(completeRepeatAction1)
        like.run(completeRepeatAction)
        settings.run(completeRepeatAction1)
        
        actionsArray.append(completeAction)
        actionsArray.append(completeRepeatAction1)
        actionsArray.append(completeActions)
        actionsArray.append(completeActionsAds)
        gameMode.run(completeActions)
        
        UserDefaults.standard.set(0, forKey: "gameMode")
    }
    
    func showSettings() {
        let darkBG = SKSpriteNode(imageNamed: "background")
        darkBG.alpha = 0.95
        darkBG.zPosition = 12
        darkBG.size = self.size
        darkBG.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        darkBG.name = "darkBG"
        addChild(darkBG)
        
        for action in actionsArray {
            action.speed = 0
        }
        
        settingsText.name = "settingsText"
        settingsText.text = NSLocalizedString("settings", comment: "settings-title")
        settingsText.fontSize = 75
        settingsText.fontColor = SKColor.white
        settingsText.zPosition = darkBG.zPosition + 1
        settingsText.horizontalAlignmentMode = .center
        settingsText.verticalAlignmentMode = .baseline
        settingsText.position = CGPoint(x: self.frame.midX, y: 700)
        addChild(settingsText)
        
        exit.name = "exit"
        exit.zPosition = settingsText.zPosition
        exit.position = CGPoint(x: 100, y: 900)
        addChild(exit)
        
        sound = SKSpriteNode(texture: soundOnTexture)
        sound.position = CGPoint(x: settingsText.position.x - 120, y: settingsText.position.y - 90)
        sound.zPosition = exit.zPosition
        addChild(sound)
        
        let soundText = SKLabelNode(fontNamed: "Montserrat-Regular")
        soundText.name = "sound-text"
        soundText.text = NSLocalizedString("sound-on", comment: "sound-on")
        soundText.fontSize = 35
        soundText.horizontalAlignmentMode = .center
        soundText.verticalAlignmentMode = .baseline
        soundText.position = CGPoint(x: sound.position.x + 130, y: sound.position.y - 10)
        soundText.zPosition = sound.zPosition
        soundText.fontColor = SKColor.white
        addChild(soundText)
        
        restorePurchases.position = CGPoint(x: sound.position.x, y: sound.position.y - 100)
        restorePurchases.zPosition = soundText.zPosition
        addChild(restorePurchases)
        
        let restoreLabel = SKLabelNode(fontNamed: "Montserrat-Regular")
        restoreLabel.name = "restoreLabel"
        restoreLabel.text = NSLocalizedString("restore", comment: "restore-purchases")
        restoreLabel.fontSize = 35
        restoreLabel.horizontalAlignmentMode = .center
        restoreLabel.verticalAlignmentMode = .baseline
        restoreLabel.position = CGPoint(x: restorePurchases.position.x + 130, y: restorePurchases.position.y)
        restoreLabel.zPosition = restorePurchases.zPosition
        restoreLabel.fontColor = SKColor.white
        addChild(restoreLabel)
        
        let restoreLabel2 = SKLabelNode(fontNamed: "Montserrat-Regular")
        restoreLabel2.name = "restore-two"
        restoreLabel2.text = NSLocalizedString("purchases", comment: "purchase-restore")
        restoreLabel2.fontSize = 35
        restoreLabel2.horizontalAlignmentMode = .center
        restoreLabel2.verticalAlignmentMode = .baseline
        restoreLabel2.position = CGPoint(x: restorePurchases.position.x + 130, y: restoreLabel.position.y - 30)
        restoreLabel2.zPosition = restorePurchases.zPosition
        restoreLabel2.fontColor = SKColor.white
        addChild(restoreLabel2)
        
        help.position = CGPoint(x: restorePurchases.position.x, y: restorePurchases.position.y - 100)
        help.zPosition = restorePurchases.zPosition
        addChild(help)
        
        let helpLabel = SKLabelNode(fontNamed: "Montserrat-Regular")
        helpLabel.name = "help-label"
        helpLabel.text = NSLocalizedString("how-to-play", comment: "help")
        helpLabel.fontSize = 35
        helpLabel.horizontalAlignmentMode = .center
        helpLabel.verticalAlignmentMode = .baseline
        helpLabel.position = CGPoint(x: help.position.x + 150, y: help.position.y - 10)
        helpLabel.zPosition = help.zPosition
        helpLabel.fontColor = SKColor.white
        addChild(helpLabel)
        
        settingsArray.append(darkBG)
        settingsArray.append(settingsText)
        settingsArray.append(exit)
        settingsArray.append(sound)
        settingsArray.append(soundText)
        settingsArray.append(restorePurchases)
        settingsArray.append(restoreLabel)
        settingsArray.append(restoreLabel2)
        settingsArray.append(help)
        settingsArray.append(helpLabel)
        
        isShowingSettings = true
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            if let label = self.label {
                label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
