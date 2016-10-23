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
    case shoot = 0
    case memory = 1
    case build = 2
    case challenge = 3
    case multiplayer = 4
    case endless = 5
    case easy = 6
    case medium = 7
    case hard = 8
    case locked = 9
    case shuffle = 10
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
    internal var currentText : UInt32 = GameMode.shoot.rawValue
    
    fileprivate let currentTexture = SKTexture(imageNamed: "ribbon")
    fileprivate var currentSize = CGSize(width: 566, height: 164)
    internal var currentMode : GameMode = .shoot
    
    fileprivate let textLabel = SKLabelNode()
    
    fileprivate var shootFrames : [SKTexture]?
    fileprivate var shootAtlas : SKTextureAtlas?
    
    fileprivate var endlessFrames : [SKTexture]?
    fileprivate var endlessAtlas : SKTextureAtlas?
    
    fileprivate var memoryFrames : [SKTexture]?
    fileprivate var memoryAtlas : SKTextureAtlas?
    
    fileprivate var buildUpFrames : [SKTexture]?
    fileprivate var buildUpAtlas : SKTextureAtlas?
    
    fileprivate var shuffleFrames : [SKTexture]?
    fileprivate var shuffleAtlas : SKTextureAtlas?
    
    internal var mainScene : SKScene?
    internal var numbersLeftToUnlock : Int?
    
    var memory = SKSpriteNode()
    var buildUp = SKSpriteNode()
    var endless = SKSpriteNode()
    var shoot = SKSpriteNode()
    var shuffle = SKSpriteNode()
    
    var initialColor: UIColor?
    var dotInitialColor: UIColor?
    
    init(ribbonType type: GameMode, bodyColour colour: BodyColour, dotsColour dotColor: DotsColour, text: String) {
        currentSize = currentTexture.size()
        currentMode = type
        super.init(texture: currentTexture, color: UIColor.clear, size: currentSize)
        
        colorBlendFactor = 1.0
        color = UIColor(rgba: colour.rawValue)
        
        initialColor = UIColor(rgba: colour.rawValue)
        dotInitialColor = UIColor(rgba: dotColor.rawValue)
        
        let dotTexture = SKTexture(imageNamed: "dots")
        
        let dots1 = SKSpriteNode(texture: dotTexture)
        dots1.position = CGPoint(x: -12, y: 32)
        dots1.zPosition = 55
        dots1.colorBlendFactor = 1.0
        dots1.name = "dots1"
        dots1.color = UIColor(rgba: dotColor.rawValue)
        addChild(dots1)
        
        let dots2 = SKSpriteNode(texture: dotTexture)
        dots2.position = CGPoint(x: -12, y: -32)
        dots2.zPosition = 55
        dots2.colorBlendFactor = 1.0
        dots2.name = "dots2"
        dots2.color = UIColor(rgba: dotColor.rawValue)
        addChild(dots2)
        
        createTextWithType(type, text: text)
    }
    
    func setNumbersLeft(_ left: Int) {
        numbersLeftToUnlock = left
    }
    
    func setSuperScene(_ scene: SKScene?)  {
        mainScene = scene!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func unlocked(_ mode: GameMode, text: String) {
        
        self.removeAllChildren()
        
        let dotTexture = SKTexture(imageNamed: "dots")
        
        let dots1 = SKSpriteNode(texture: dotTexture)
        dots1.position = CGPoint(x: -12, y: 32)
        dots1.zPosition = 55
        dots1.colorBlendFactor = 1.0
        dots1.name = "dots1"
        addChild(dots1)
        
        let dots2 = SKSpriteNode(texture: dotTexture)
        dots2.position = CGPoint(x: -12, y: -32)
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
        dots1.position = CGPoint(x: -12, y: 32)
        dots1.zPosition = 55
        dots1.colorBlendFactor = 1.0
        dots1.name = "dots1"
        addChild(dots1)
        
        let dots2 = SKSpriteNode(texture: dotTexture)
        dots2.position = CGPoint(x: -12, y: -32)
        dots2.zPosition = 55
        dots2.colorBlendFactor = 1.0
        dots2.name = "dots2"
        addChild(dots2)
        
        
        dots1.color = UIColor(rgba: DotsColour.Grey.rawValue)
        dots2.color = UIColor(rgba: DotsColour.Grey.rawValue)
        
        createCustom("LOCKED".localized)
        
    }
    
    func createTextWithType(_ type : GameMode, text: String) {
        switch type {
        case .endless:
            createEndless()
            break;
        case .shoot:
            createShoot()
            break
            
        case .memory:
            createMemory()
            break
            
        case .build:
            //Set mode to Build-Up
            createBuildUp()
            break;
            
        case .challenge:
            //createChallenge()
            break;
            
        case .multiplayer:
            createMultiplayer()
            break;
            
        case .locked:
            locked()
            break;
        
        case .shuffle:
            createShuffle()
            break;
            
        default:
            createCustom(text)
            break;
        }
        
    }
    
    fileprivate func createMultiplayer() {
        let multiLabel = SKLabelNode(fontNamed: k.Montserrat.Regular)
        multiLabel.text = "MULTIPLAYER".localized
        multiLabel.zPosition = 38
        multiLabel.fontColor = UIColor.white
        multiLabel.horizontalAlignmentMode = .center
        multiLabel.verticalAlignmentMode = .center
        multiLabel.fontSize = 28
        addChild(multiLabel)
    }
    
    
    fileprivate func createCustom(_ text: String) {
        let customText = SKLabelNode(fontNamed: k.Montserrat.Regular)
        customText.name = "customText"
        customText.text = text
        customText.zPosition = 38
        customText.fontColor = UIColor.white
        customText.horizontalAlignmentMode = .center
        customText.verticalAlignmentMode = .center
        customText.fontSize = 28
        addChild(customText)
    }
    
    fileprivate func createShoot() {
        shootFrames = [SKTexture]()
        shootAtlas = SKTextureAtlas(named: "Shoot-Atlas".localized)
        
        let numImages = shootAtlas!.textureNames.count
        var shootAnimFrames = [SKTexture]()
        
        for i in 0...numImages - 1 {
            let imgName = "Shoot" + String(i) + ".png"
            var temp = shootAtlas?.textureNamed(imgName)
            shootAnimFrames.append(temp!)
            temp = nil
        }
        shootFrames = shootAnimFrames
        
        var temp : SKTexture? = shootFrames![0]
        
        shoot = SKSpriteNode(texture: temp)
        shoot.position = CGPoint(x: 2, y: -0)
        shoot.zPosition = 33
        shoot.name = "shoot"
        shoot.setScale(0.30)
        addChild(shoot)
        
        temp = nil
        
        animate(shoot, frames: shootFrames!, speed: 0.33)
    }
    
    fileprivate func createShuffle() {
        shuffleFrames = [SKTexture]()
        shuffleAtlas = SKTextureAtlas(named: "Shuffle-Atlas".localized)
        
        let numImages = shuffleAtlas!.textureNames.count
        var shuffleAnimFrames = [SKTexture]()
        
        for i in 0...numImages - 1 {
            let imgName = "Shuffle" + String(i) + ".png"
            var temp = shuffleAtlas?.textureNamed(imgName)
            shuffleAnimFrames.append(temp!)
            temp = nil
        }
        shuffleFrames = shuffleAnimFrames
        
        var temp : SKTexture? = shuffleFrames![0]
        
        shuffle = SKSpriteNode(texture: temp)
        shuffle.position = CGPoint(x: 2, y: -0)
        shuffle.zPosition = 33
        shuffle.name = "shoot"
        shuffle.setScale(0.30)
        addChild(shuffle)
        
        temp = nil
        
        animate(shuffle, frames: shuffleFrames!, speed: 0.33)
    }
    
    fileprivate func createEndless() {
        endlessFrames = [SKTexture]()
        endlessAtlas = SKTextureAtlas(named: "Endless-Atlas".localized)
        
        let numImages = endlessAtlas!.textureNames.count
        var endlessAnimFrames = [SKTexture]()
        
        for i in 0...numImages - 1 {
            let imgName = "Endless" + String(i) + ".png"
            var temp = endlessAtlas?.textureNamed(imgName)
            endlessAnimFrames.append(temp!)
            temp = nil
        }
        endlessFrames = endlessAnimFrames
        
        var temp : SKTexture? = endlessFrames![0]
        
        endless = SKSpriteNode(texture: temp)
        endless.position = CGPoint(x: 2, y: -0)
        endless.zPosition = 33
        endless.name = "endless"
        endless.setScale(0.30)
        addChild(endless)
        
        temp = nil
        
        animate(endless, frames: endlessFrames!, speed: 0.33)
    }
    
    fileprivate func createBuildUp() {
        buildUpFrames = [SKTexture]()
        buildUpAtlas = SKTextureAtlas(named: "Build-Up-Atlas".localized)
        
        let numImages = buildUpAtlas!.textureNames.count
        var buildUpAnimFrames = [SKTexture]()
        
        for i in 0...numImages - 1 {
            let imgName = "BuildUp" + String(i) + ".png"
            var temp = buildUpAtlas?.textureNamed(imgName)
            buildUpAnimFrames.append(temp!)
            temp = nil
        }
        buildUpFrames = buildUpAnimFrames
        
        var temp : SKTexture? = buildUpFrames![0]
        
        buildUp = SKSpriteNode(texture: temp)
        buildUp.position = CGPoint(x: 2, y: -0)
        buildUp.zPosition = 33
        buildUp.name = "endless"
        buildUp.setScale(0.30)
        addChild(buildUp)
        
        temp = nil
        
        animate(buildUp, frames: buildUpFrames!, speed: 0.33)
    }
    
    fileprivate func createMemory() {
        memoryFrames = [SKTexture]()
        memoryAtlas = SKTextureAtlas(named: "Memory-Atlas".localized)
        
        let numImages = memoryAtlas!.textureNames.count
        var memoryAnimFrames = [SKTexture]()
        
        for i in 0...numImages - 1 {
            let imgName = "Memory" + String(i) + ".png"
            var temp = memoryAtlas?.textureNamed(imgName)
            memoryAnimFrames.append(temp!)
            temp = nil
            
        }
        memoryFrames = memoryAnimFrames
        
        var temp : SKTexture? = memoryFrames![0]
        
        memory = SKSpriteNode(texture: temp)
        memory.position = CGPoint(x: 2, y: -0)
        memory.zPosition = 33
        memory.name = "memory"
        memory.setScale(0.28)
        self.addChild(memory)
        
        temp = nil
        
        animate(memory, frames: memoryFrames!, speed: 0.5)
    }
    
    func animate(_ sprite: SKSpriteNode, frames: [SKTexture], speed : CGFloat) {
        
        let anim = SKAction.animate(with: frames, timePerFrame: 0.033, resize: false, restore: true)
        sprite.run(SKAction.repeatForever(anim))
        
    }
    
    func animateBall(_ ball  : SKShapeNode, word : SKLabelNode) {
        ball.run(SKAction.moveTo(x: word.position.x, duration: 2)) {
            word.run(SKAction.fadeOut(withDuration: 2), completion: {
                ball.run(SKAction.hide())
                ball.position.x = -171
            })
        }
    }
    
    fileprivate func presentScene(_ aScene : SKScene, _ mode: GameMode) {
        currentMode = mode
        
        var color : UIColor? = UIColor(rgba: "#434343")
        var transition : SKTransition? = SKTransition.fade(with: color!, duration: 2)
        
        mainScene?.view?.presentScene(scene!, transition: transition!)
        
        transition = nil
        color = nil
    }
    
    
    deinit {
        shootFrames = nil
        shootAtlas = nil
        
        childNode(withName: "shoot")?.removeAllChildren()
        childNode(withName: "shoot")?.removeAllActions()
        childNode(withName: "shoot")?.removeFromParent()
        
        childNode(withName: "memory")?.removeAllChildren()
        childNode(withName: "memory")?.removeAllActions()
        childNode(withName: "memory")?.removeFromParent()
        
        removeAllActions()
        removeAllChildren()
        
        mainScene = nil
        
    }
}
