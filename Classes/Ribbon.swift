//
//  Ribbon.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

import SpriteKit
import Foundation
import UIKit

let shootAnimKey = "shootAnimKey"

enum GameMode : UInt32 {
    case Shoot = 0
    case Memory = 1
    case Build = 2
    case Challenge = 3
    case Multiplayer = 4
    case Endless = 5
    case Easy = 6
    case Medium = 7
    case Hard = 8
    case Locked = 9
}

class Ribbon: SKSpriteNode {
    
    enum BodyColour : String {
        case Red = "#e74c3c"
        case Turqouise = "#1abc9c"
        case Green = "#27ae60"
        case Purple = "#9b59b6"
        case DarkBlue = "#34495e"
        case LightBlue = "#7893FF"
        case LightRed = "#FF7878"
        case Orange = "#FFAD29"
        case Grey = "#808080"
    }
    
    enum DotsColour : String {
        case Red = "#ff9878"
        case Turqouise = "#34ffff"
        case Green = "#4effc0"
        case Purple = "#ffb2ff"
        case DarkBlue = "#6892bc"
        case LightBlue = "#C4D0FF"
        case LightRed = "#F7C8C8"
        case Orange = "#FACE87"
        case Grey = "#C7C7C7"
    }
    
    
    
    internal var currentBodyColour : String = BodyColour.Red.rawValue
    internal var currentDotsColour : String = DotsColour.Red.rawValue
    internal var currentText : UInt32 = GameMode.Shoot.rawValue
    
    private let currentTexture = SKTexture(imageNamed: "ribbon")
    private var currentSize = CGSizeMake(566, 164)
    internal var currentMode : GameMode = .Shoot
    
    private let textLabel = SKLabelNode()
    
    private var shootFrames : [SKTexture]?
    private var shootAtlas : SKTextureAtlas?
    
    private var endlessFrames : [SKTexture]?
    private var endlessAtlas : SKTextureAtlas?
    
    private var memoryFrames : [SKTexture]?
    private var memoryAtlas : SKTextureAtlas?
    
    private var buildUpFrames : [SKTexture]?
    private var buildUpAtlas : SKTextureAtlas?
    
    internal var mainScene : SKScene?
    internal var numbersLeftToUnlock : Int?
    
    var memory = SKSpriteNode()
    var buildUp = SKSpriteNode()
    var endless = SKSpriteNode()
    var shoot = SKSpriteNode()
    
    var initialColor: UIColor?
    var dotInitialColor: UIColor?
    
    init(ribbonType type: GameMode, bodyColour colour: BodyColour, dotsColour dotColor: DotsColour, text: String) {
        currentSize = currentTexture.size()
        currentMode = type
        super.init(texture: currentTexture, color: UIColor.clearColor(), size: currentSize)
        
        colorBlendFactor = 1.0
        color = UIColor(rgba: colour.rawValue)
        
        initialColor = UIColor(rgba: colour.rawValue)
        dotInitialColor = UIColor(rgba: dotColor.rawValue)
        
        let dotTexture = SKTexture(imageNamed: "dots")
        
        let dots1 = SKSpriteNode(texture: dotTexture)
        dots1.position = CGPointMake(-12, 32)
        dots1.zPosition = 55
        dots1.colorBlendFactor = 1.0
        dots1.name = "dots1"
        dots1.color = UIColor(rgba: dotColor.rawValue)
        addChild(dots1)
        
        let dots2 = SKSpriteNode(texture: dotTexture)
        dots2.position = CGPointMake(-12, -32)
        dots2.zPosition = 55
        dots2.colorBlendFactor = 1.0
        dots2.name = "dots2"
        dots2.color = UIColor(rgba: dotColor.rawValue)
        addChild(dots2)
        
        createTextWithType(type, text: text)
    }
    
    func setNumbersLeft(left: Int) {
        numbersLeftToUnlock = left
    }
    
    func setSuperScene(scene: SKScene?)  {
        mainScene = scene!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func unlocked(mode: GameMode, text: String) {
        
        self.removeAllChildren()
        
        let dotTexture = SKTexture(imageNamed: "dots")
        
        let dots1 = SKSpriteNode(texture: dotTexture)
        dots1.position = CGPointMake(-12, 32)
        dots1.zPosition = 55
        dots1.colorBlendFactor = 1.0
        dots1.name = "dots1"
        addChild(dots1)
        
        let dots2 = SKSpriteNode(texture: dotTexture)
        dots2.position = CGPointMake(-12, -32)
        dots2.zPosition = 55
        dots2.colorBlendFactor = 1.0
        dots2.name = "dots2"
        addChild(dots2)
        
        color = initialColor!
        
        dots1.color = dotInitialColor!
        dots2.color = dotInitialColor!
        
        createTextWithType(mode, text: text)
    }
    
    func locked() {
        self.removeAllChildren()
        
        color = UIColor(rgba: BodyColour.Grey.rawValue)
        
        let dotTexture = SKTexture(imageNamed: "dots")
        
        let dots1 = SKSpriteNode(texture: dotTexture)
        dots1.position = CGPointMake(-12, 32)
        dots1.zPosition = 55
        dots1.colorBlendFactor = 1.0
        dots1.name = "dots1"
        addChild(dots1)
        
        let dots2 = SKSpriteNode(texture: dotTexture)
        dots2.position = CGPointMake(-12, -32)
        dots2.zPosition = 55
        dots2.colorBlendFactor = 1.0
        dots2.name = "dots2"
        addChild(dots2)
        
        
        dots1.color = UIColor(rgba: DotsColour.Grey.rawValue)
        dots2.color = UIColor(rgba: DotsColour.Grey.rawValue)
        
        /*if children.contains(shoot) {
         shoot.removeFromParent()
         shoot.removeAllActions()
         } else if children.contains(memory) {
         memory.removeFromParent()
         memory.removeAllActions()
         } else if children.contains(endless) {
         endless.removeFromParent()
         endless.removeAllActions()
         } else if children.contains(buildUp) {
         buildUp.removeFromParent()
         buildUp.removeAllActions()
         }
         
         if let labelNode = childNodeWithName("customText") as? SKLabelNode {
         labelNode.text = "LOCKED"
         } else {
         createCustom("LOCKED")
         
         }*/
        
        createCustom("LOCKED")
        
    }
    
    func createTextWithType(type : GameMode, text: String) {
        switch type {
        case .Endless:
            createEndless()
            break;
        case .Shoot:
            createShoot()
            break
            
        case .Memory:
            createMemory()
            break
            
        case .Build:
            //Set mode to Build-Up
            createBuildUp()
            break;
            
        case .Challenge:
            //createChallenge()
            break;
            
        case .Multiplayer:
            createMultiplayer()
            break;
            
        case .Locked:
            locked()
            break;
            
        default:
            createCustom(text)
            break;
        }
        
    }
    
    private func createMultiplayer() {
        let multiLabel = SKLabelNode(fontNamed: k.Montserrat.Regular)
        multiLabel.text = "MULTIPLAYER"
        multiLabel.zPosition = 38
        multiLabel.fontColor = UIColor.whiteColor()
        multiLabel.horizontalAlignmentMode = .Center
        multiLabel.verticalAlignmentMode = .Center
        multiLabel.fontSize = 28
        addChild(multiLabel)
    }
    
    
    private func createCustom(text: String) {
        let customText = SKLabelNode(fontNamed: k.Montserrat.Regular)
        customText.name = "customText"
        customText.text = text
        customText.zPosition = 38
        customText.fontColor = UIColor.whiteColor()
        customText.horizontalAlignmentMode = .Center
        customText.verticalAlignmentMode = .Center
        customText.fontSize = 28
        addChild(customText)
    }
    
    private func createShoot() {
        shootFrames = [SKTexture]()
        shootAtlas = SKTextureAtlas(named: "Shoot")
        
        let numImages = shootAtlas!.textureNames.count
        var shootAnimFrames = [SKTexture]()
        
        for var i = 0; i <= numImages - 1; i += 1 {
            let imgName = "Shoot" + String(i) + ".png"
            var temp = shootAtlas?.textureNamed(imgName)
            shootAnimFrames.append(temp!)
            temp = nil
        }
        shootFrames = shootAnimFrames
        
        var temp : SKTexture? = shootFrames![0]
        
        shoot = SKSpriteNode(texture: temp)
        shoot.position = CGPointMake(2, -0)
        shoot.zPosition = 33
        shoot.name = "shoot"
        shoot.setScale(0.30)
        addChild(shoot)
        
        temp = nil
        
        animate(shoot, frames: shootFrames!, speed: 0.33)
    }
    
    private func createEndless() {
        endlessFrames = [SKTexture]()
        endlessAtlas = SKTextureAtlas(named: "Endless")
        
        let numImages = endlessAtlas!.textureNames.count
        var endlessAnimFrames = [SKTexture]()
        
        for var i = 0; i <= numImages - 1; i += 1 {
            let imgName = "Endless" + String(i) + ".png"
            var temp = endlessAtlas?.textureNamed(imgName)
            endlessAnimFrames.append(temp!)
            temp = nil
        }
        endlessFrames = endlessAnimFrames
        
        var temp : SKTexture? = endlessFrames![0]
        
        endless = SKSpriteNode(texture: temp)
        endless.position = CGPointMake(2, -0)
        endless.zPosition = 33
        endless.name = "endless"
        endless.setScale(0.30)
        addChild(endless)
        
        temp = nil
        
        animate(endless, frames: endlessFrames!, speed: 0.33)
    }
    
    private func createBuildUp() {
        buildUpFrames = [SKTexture]()
        buildUpAtlas = SKTextureAtlas(named: "Build-Up")
        
        let numImages = buildUpAtlas!.textureNames.count
        var buildUpAnimFrames = [SKTexture]()
        
        for var i = 0; i <= numImages - 1; i += 1 {
            let imgName = "BuildUp" + String(i) + ".png"
            var temp = buildUpAtlas?.textureNamed(imgName)
            buildUpAnimFrames.append(temp!)
            temp = nil
        }
        buildUpFrames = buildUpAnimFrames
        
        var temp : SKTexture? = buildUpFrames![0]
        
        buildUp = SKSpriteNode(texture: temp)
        buildUp.position = CGPointMake(2, -0)
        buildUp.zPosition = 33
        buildUp.name = "endless"
        buildUp.setScale(0.30)
        addChild(buildUp)
        
        temp = nil
        
        animate(buildUp, frames: buildUpFrames!, speed: 0.33)
    }
    
    private func createMemory() {
        memoryFrames = [SKTexture]()
        memoryAtlas = SKTextureAtlas(named: "Memory")
        
        let numImages = memoryAtlas!.textureNames.count
        var memoryAnimFrames = [SKTexture]()
        
        for var i = 0; i <= numImages - 1; i += 1 {
            let imgName = "Memory" + String(i) + ".png"
            var temp = memoryAtlas?.textureNamed(imgName)
            memoryAnimFrames.append(temp!)
            temp = nil
            
        }
        memoryFrames = memoryAnimFrames
        
        var temp : SKTexture? = memoryFrames![0]
        
        memory = SKSpriteNode(texture: temp)
        memory.position = CGPointMake(2, -0)
        memory.zPosition = 33
        memory.name = "memory"
        memory.setScale(0.28)
        self.addChild(memory)
        
        temp = nil
        
        animate(memory, frames: memoryFrames!, speed: 0.5)
    }
    
    func animate(sprite: SKSpriteNode, frames: [SKTexture], speed : CGFloat) {
        
        let anim = SKAction.animateWithTextures(frames, timePerFrame: 0.033, resize: false, restore: true)
        sprite.runAction(SKAction.repeatActionForever(anim))
        
    }
    
    func animateBall(ball  : SKShapeNode, word : SKLabelNode) {
        ball.runAction(SKAction.moveToX(word.position.x, duration: 2)) {
            word.runAction(SKAction.fadeOutWithDuration(2), completion: {
                ball.runAction(SKAction.hide())
                ball.position.x = -171
            })
        }
    }
    
    private func presentScene(aScene : SKScene, _ mode: GameMode) {
        currentMode = mode
        
        var color : UIColor? = UIColor(rgba: "#434343")
        var transition : SKTransition? = SKTransition.fadeWithColor(color!, duration: 2)
        
        mainScene?.view?.presentScene(scene!, transition: transition!)
        
        transition = nil
        color = nil
    }
    
    
    deinit {
        shootFrames = nil
        shootAtlas = nil
        
        childNodeWithName("shoot")?.removeAllChildren()
        childNodeWithName("shoot")?.removeAllActions()
        childNodeWithName("shoot")?.removeFromParent()
        
        childNodeWithName("memory")?.removeAllChildren()
        childNodeWithName("memory")?.removeAllActions()
        childNodeWithName("memory")?.removeFromParent()
        
        removeAllActions()
        removeAllChildren()
        
        mainScene = nil
        
    }
}