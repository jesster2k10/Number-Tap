//
//  GameModes.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Flatbox Studio. All rights reserved.
//

import SpriteKit
import StoreKit
import NHNetworkTime

let kVideoEnabled = "enabled"

class GameModes: SKScene {
    weak var scrollView: SKScrollView!
    let moveableNode              = SKSpriteNode()
    let background                = SKSpriteNode(imageNamed: "background")
    let titleBG                   = SKSpriteNode(imageNamed: "titleBG")
    let darkStrip                 = SKSpriteNode(imageNamed: "darkStrip")
    let leaderboard               = SKSpriteNode(imageNamed: "leaderboard")
    let home                      = SKSpriteNode(imageNamed: "home")
    let gameModes                 = SKLabelNode(fontNamed: k.Montserrat.SemiBold)
    let numbersTapped             = SKLabelNode(fontNamed: k.Montserrat.Regular)
    let numbers                   = SKLabelNode(fontNamed: k.Montserrat.Light)
    let endlessRibbon             = Ribbon(ribbonType: .Endless, bodyColour: .Purple, dotsColour: .Purple, text: "")
    let shootRibbon               = Ribbon(ribbonType: .Shoot, bodyColour: .Red, dotsColour: .Red, text: "")
    let memoryRibbon              = Ribbon(ribbonType: .Memory, bodyColour: .Turqouise, dotsColour: .Turqouise, text: "")
    let multiplayerRibbon         = Ribbon(ribbonType: .Multiplayer, bodyColour: .DarkBlue, dotsColour: .DarkBlue, text: "")
    let buildUpRibbon             = Ribbon(ribbonType: .Build, bodyColour: .Green, dotsColour: .Green, text: "")
    let easyRibbon                = Ribbon(ribbonType: .Easy, bodyColour: .LightBlue, dotsColour: .LightBlue, text: "EASY")
    let mediumRibbon              = Ribbon(ribbonType: .Medium, bodyColour: .Orange, dotsColour: .Orange, text: "MEDIUM")
    let impossibleRibbon          = Ribbon(ribbonType: .Hard, bodyColour: .LightRed, dotsColour: .LightRed, text: "HARD")
    
    var ribbons                   = [Ribbon]()
    var nodesTouched: [AnyObject] = []
    var lockedModes               = [Ribbon]()
    var products                  = [SKProduct]()
    var titlesArray               = [SKLabelNode]()
    
    //TODO: Create new leaderboards for the different game modes
    override func didMoveToView(view: SKView) {
        scaleMode = .AspectFill
        size = CGSizeMake(640, 960)
        
        NSNotificationCenter.defaultCenter().postNotificationName("showBanner", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(rewardUser(_:)), name: "videoRewarded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(developerMode), name: "DeveloperMode", object: nil)
        
        products = []
        Products.store.requestProductsWithCompletionHandler { (success, products) in
            if success {
                self.products = products
            }
        }
        
        if !UIScreen.mainScreen().isRetina() {
            scrollView = SKScrollView(frame: CGRect(x: 0, y: 0, width: 10240, height: self.frame.size.height - 250), moveableNode: moveableNode, scrollDirection: .vertical, scene: self)
        } else {
            scrollView = SKScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - 250), moveableNode: moveableNode, scrollDirection: .vertical, scene: self)
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height * 1.5) // makes it 3 times the height
        view.addSubview(scrollView)
        addChild(moveableNode)
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.size = self.size
        background.zPosition = -1
        addChild(background)
        
        if !UIScreen.mainScreen().isRetina() {
            titleBG.position = CGPointMake(CGRectGetMidX(self.frame), 860)
        } else {
            titleBG.position = CGPointMake(CGRectGetMidX(self.frame), 920)
        }
        titleBG.setScale(1.3)
        
        gameModes.text = NSLocalizedString("game-modes", comment: "Game Modes")
        gameModes.horizontalAlignmentMode = .Center
        gameModes.verticalAlignmentMode = .Center
        gameModes.zPosition = 10
        gameModes.fontSize = 50
        
        titleBG.addChild(gameModes)
        
        let gameModesShadow = SKLabelNode(fontNamed: k.Montserrat.SemiBold)
        gameModesShadow.color = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        gameModesShadow.alpha = 0.21
        gameModesShadow.position = CGPointMake(gameModes.position.x, gameModes.position.y - 3)
        gameModesShadow.horizontalAlignmentMode = .Center
        gameModesShadow.verticalAlignmentMode = .Center
        gameModesShadow.zPosition = 10
        gameModesShadow.fontSize = 65
        titleBG.addChild(gameModesShadow)
        titleBG.zPosition = moveableNode.zPosition + 1000
        addChild(titleBG)
        
        if !UIScreen.mainScreen().isRetina() {
            darkStrip.xScale = 2.5
            darkStrip.position = CGPointMake(titleBG.position.x, titleBG.position.y - 100)
            
        } else {
            darkStrip.xScale = 2.5
            darkStrip.position = CGPointMake(titleBG.position.x, titleBG.position.y - 120)
        }
        moveableNode.addChild(darkStrip)
        
        numbersTapped.position = CGPointMake(darkStrip.position.x - 140, darkStrip.position.y - 10)
        numbersTapped.text = "Numbers Tapped:"
        numbersTapped.fontSize = 24
        numbersTapped.fontColor = UIColor.whiteColor()
        numbersTapped.horizontalAlignmentMode = .Center
        numbersTapped.zPosition = 333
        moveableNode.addChild(numbersTapped)
        
        numbers.position = CGPointMake(numbersTapped.position.x + 125, numbersTapped.position.y + 1)
        numbers.text = String(NSUserDefaults.standardUserDefaults().integerForKey(kNumbersKey))
        numbers.fontColor = numbersTapped.fontColor
        numbers.fontSize = numbersTapped.fontSize - 4
        numbers.horizontalAlignmentMode = .Center
        numbers.zPosition = 333
        moveableNode.addChild(numbers)
        
        leaderboard.position = CGPointMake(darkStrip.position.x + 180, darkStrip.position.y)
        leaderboard.zPosition = 33
        leaderboard.name = "leaderboard"
        moveableNode.addChild(leaderboard)
        
        home.position = CGPointMake(leaderboard.position.x - 72, leaderboard.position.y)
        home.zPosition = leaderboard.zPosition
        home.setScale(1.5)
        home.name = "home"
        moveableNode.addChild(home)
        
        endlessRibbon.position = CGPointMake(203, 651)
        endlessRibbon.setScale(1.5)
        endlessRibbon.setSuperScene(self)
        moveableNode.addChild(endlessRibbon)
        
        easyRibbon.position = CGPointMake(endlessRibbon.position.x, endlessRibbon.position.y - 150)
        easyRibbon.setScale(1.5)
        easyRibbon.setSuperScene(self)
        moveableNode.addChild(easyRibbon)
        
        impossibleRibbon.position = CGPointMake(easyRibbon.position.x, easyRibbon.position.y - 150)
        impossibleRibbon.setScale(1.5)
        impossibleRibbon.setSuperScene(self)
        moveableNode.addChild(impossibleRibbon)
        
        shootRibbon.position = CGPointMake(203, impossibleRibbon.position.y - 150)
        shootRibbon.setScale(1.5)
        shootRibbon.setSuperScene(self)
        moveableNode.addChild(shootRibbon)
        
        memoryRibbon.position = CGPointMake(shootRibbon.position.x, shootRibbon.position.y - 150)
        memoryRibbon.setScale(1.5)
        memoryRibbon.setSuperScene(self)
        moveableNode.addChild(memoryRibbon)
        
        buildUpRibbon.position = CGPointMake(memoryRibbon.position.x, memoryRibbon.position.y - 150)
        buildUpRibbon.setScale(1.5)
        buildUpRibbon.setSuperScene(self)
        moveableNode.addChild(buildUpRibbon)
        
        multiplayerRibbon.position = CGPointMake(buildUpRibbon.position.x, buildUpRibbon.position.y - 150)
        multiplayerRibbon.setScale(1.5)
        multiplayerRibbon.setSuperScene(self)
        moveableNode.addChild(multiplayerRibbon)
        
        ribbons.append(endlessRibbon)
        ribbons.append(easyRibbon)
        ribbons.append(mediumRibbon)
        ribbons.append(impossibleRibbon)
        ribbons.append(shootRibbon)
        ribbons.append(memoryRibbon)
        ribbons.append(multiplayerRibbon)
        ribbons.append(buildUpRibbon)
        
        setupModes()
        
        if NSUserDefaults.keyAlreadyExists(kNumbersKey) {
            let tapped = NSUserDefaults.standardUserDefaults().integerForKey(kNumbersKey)
            let checkArray = [k.numbersToUnlock.buildUp, k.numbersToUnlock.easy, k.numbersToUnlock.medium, k.numbersToUnlock.hard, k.numbersToUnlock.shoot, k.numbersToUnlock.memory, k.numbersToUnlock.multiplayer, k.numbersToUnlock.endless, k.numbersToUnlock.shoot]
            
            for number in checkArray {
                if tapped == number {
                    switch number {
                    case k.numbersToUnlock.buildUp:
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: k.isUnlocked.buildUp)
                    case k.numbersToUnlock.easy:
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: k.isUnlocked.easy)
                    case k.numbersToUnlock.medium:
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: k.isUnlocked.medium)
                    case k.numbersToUnlock.hard:
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: k.isUnlocked.hard)
                    case k.numbersToUnlock.shoot:
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: k.isUnlocked.shoot)
                    case k.numbersToUnlock.memory:
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: k.isUnlocked.memory)
                    case k.numbersToUnlock.endless:
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: k.isUnlocked.endless)
                    case k.numbersToUnlock.multiplayer:
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: k.isUnlocked.multiplayer)
                    default:
                        break;
                    }
                    
                    print("New level is unlocked")
                    setupModes()
                }
            }
        }
        
        if !NSUserDefaults.keyAlreadyExists(kVideoEnabled) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: kVideoEnabled)
        }
        
    }
    
    func setupModes() {
        var tapped = 0
        
        if NSUserDefaults.keyAlreadyExists(kNumbersKey) {
            tapped = NSUserDefaults.standardUserDefaults().integerForKey(kNumbersKey)
        } else {
            tapped = 0
        }
        
        for title in titlesArray {
            if moveableNode.children.contains(title) {
                title.removeAllActions()
                title.removeFromParent()
            }
        }
        
        if modeIsUnlocked(k.isUnlocked.endless) {
            setupText(endlessRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: NSUserDefaults.standardUserDefaults().highScore)
            endlessRibbon.unlocked(GameMode.Endless, text: "")
        } else {
            setupText(endlessRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.endless, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.easy) {
            setupText(easyRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: NSUserDefaults.standardUserDefaults().highScore)
            easyRibbon.unlocked(GameMode.Easy, text: "EASY")
        } else {
            setupText(easyRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.easy, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.hard) {
            setupText(impossibleRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: NSUserDefaults.standardUserDefaults().highScore)
            impossibleRibbon.unlocked(GameMode.Hard, text: "IMPOSSIBLE")
        } else {
            setupText(impossibleRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.hard, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.shoot) {
            setupText(shootRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: nil)
            shootRibbon.unlocked(GameMode.Shoot, text: "")
        } else {
            setupText(shootRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.shoot, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.memory) {
            setupText(memoryRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: nil)
            memoryRibbon.unlocked(GameMode.Memory, text: "")
        } else {
            setupText(memoryRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.memory, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.multiplayer) {
            setupText(multiplayerRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: nil)
            multiplayerRibbon.unlocked(GameMode.Multiplayer, text: "")
        } else {
            setupText(multiplayerRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.multiplayer, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.buildUp) {
            setupText(buildUpRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: nil)
            buildUpRibbon.unlocked(GameMode.Build, text: "")
        } else {
            setupText(buildUpRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.buildUp, currentTapped: tapped, bestScore: nil)
        }
    }
    
    func image(fromOriginalImage origImage: CGImage, withHue hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> UIImage {
        let image = UIImage(CGImage: origImage)
        
        let rect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: image.size)
        
        UIGraphicsBeginImageContext(image.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextTranslateCTM(context, 0.0, image.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        CGContextDrawImage(context, rect, image.CGImage)
        
        CGContextSetBlendMode(context, CGBlendMode.Hue)
        
        CGContextClipToMask(context, rect, image.CGImage)
        CGContextSetFillColorWithColor(context, UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0).CGColor)
        CGContextFillRect(context, rect)
        
        let colouredImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        return colouredImage
    }
    
    func modeIsUnlocked(mode: String) -> Bool {
        if !NSUserDefaults.keyAlreadyExists(mode) {
            return false
        }
        
        return true
    }
    
    //TODO: Make sure nodes are being added to the locked array
    func setupText(ribbon: Ribbon, unlocked: Bool = false, numbersNeededToUnlock: Int?, currentTapped: Int?, bestScore: Int? = 0) {
        if numbersNeededToUnlock != nil && currentTapped != nil {
            ribbon.setNumbersLeft(numbersNeededToUnlock! - currentTapped!)
        }
        let topLabel = SKLabelNode(fontNamed: k.Montserrat.SemiBold)
        let bottomLabelOne = SKLabelNode(fontNamed: k.Montserrat.Light)
        let bottomLabelTwo = SKLabelNode(fontNamed: k.Montserrat.Light)
        
        topLabel.position = CGPointMake(ribbon.position.x + 300, ribbon.position.y + 10)
        topLabel.horizontalAlignmentMode = .Center
        topLabel.verticalAlignmentMode = .Baseline
        topLabel.fontSize = 25
        topLabel.fontColor = UIColor.whiteColor()
        topLabel.name = "top-label"
        moveableNode.addChild(topLabel)
        
        bottomLabelOne.position = CGPointMake(topLabel.position.x, topLabel.position.y - 30)
        bottomLabelOne.horizontalAlignmentMode = topLabel.horizontalAlignmentMode
        bottomLabelOne.verticalAlignmentMode = topLabel.verticalAlignmentMode
        bottomLabelOne.fontSize = topLabel.fontSize
        bottomLabelOne.fontColor = topLabel.fontColor
        bottomLabelOne.name = "bottom-label-1"
        moveableNode.addChild(bottomLabelOne)
        
        bottomLabelTwo.position = CGPointMake(bottomLabelOne.position.x, bottomLabelOne.position.y - 28)
        bottomLabelTwo.horizontalAlignmentMode = bottomLabelOne.horizontalAlignmentMode
        bottomLabelTwo.verticalAlignmentMode = bottomLabelOne.verticalAlignmentMode
        bottomLabelTwo.fontSize = bottomLabelOne.fontSize
        bottomLabelTwo.fontColor = bottomLabelOne.fontColor
        bottomLabelTwo.name = "bottom-label-2"
        moveableNode.addChild(bottomLabelTwo)
        
        titlesArray.append(topLabel)
        titlesArray.append(bottomLabelOne)
        titlesArray.append(bottomLabelTwo)
        
        if unlocked {
            if bestScore != nil {
                topLabel.text = String(bestScore!)
            } else {
                topLabel.text = "0"
            }
            bottomLabelOne.text = "best"
            bottomLabelTwo.text = "score"
            
        } else {
            lockedModes.append(ribbon)
            
            ribbon.locked()
            
            let numbersLeft = numbersNeededToUnlock! - currentTapped!
            topLabel.text = String(numbersLeft)
            bottomLabelOne.text = "numbers"
            bottomLabelTwo.text = "left to tap"
            
        }
    }
    
    func showVideoAlert() {
        let alert = PMAlertController(title: "Watch a video", description: "Want to get 50 taps by watching a short video?", image: nil, style: .Alert)
        alert.addAction(PMAlertAction(title: "Yes!", style: .Default, action: {
            //TODO: Show rewarded video
            //TODO: Don't Allow them do it again for the day
            if Supersonic.sharedInstance().isAdAvailable() {
                print("Showing thingh")
                Supersonic.sharedInstance().showRVWithPlacementName("Game_Modes")
                
                let date = NSDate()
                let networkDate = NSDate.networkDate()
                
                if NSDate.daysBetweenThisDate(date, andThisDate: networkDate) < 1 {
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: kVideoEnabled)
                } else if NSDate.daysBetweenThisDate(date, andThisDate: networkDate) > 1  {
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: kVideoEnabled)
                }
            }
        }))
        
        alert.addAction(PMAlertAction(title: "No", style: .Cancel, action: {
            print("cancel")
            //TODO: Allow them do it again for the day
        }))
        
        let vc = self.view?.window?.rootViewController!
        NSTimer.after(0.01) {
            vc?.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = nodeAtPoint(location)
            
            if node == home { // or check for spriteName  ->  if node.name == "SpriteName"
                scrollView.removeFromSuperview()
                let scene = HomeScene()
                self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
            }
            
            if node == leaderboard {
                scrollView.removeFromSuperview()
                GCHelper.sharedGameKitHelper.showGameCenter((view?.window?.rootViewController)!, viewState: .Leaderboards)
            }
            
            for mode in lockedModes {
                if node == mode {
                    let alert = PMAlertController(title: "Locked Game Mode", description: "This mode is locked! You have to tap another \(mode.numbersLeftToUnlock!) numbers to unlock this mode. You must keep on tapping!", image: nil, style: .Walkthrough)
                    alert.addAction(PMAlertAction(title: "Unlock all modes", style: .Default, action: {
                        self.purchaseProduct(1)
                    }))
                    
                    alert.addAction(PMAlertAction(title: "Unlock this mode", style: .Default, action: {
                        //TODO: Set up IAP to unlock all of the levels.
                    }))
                    
                    if NSUserDefaults.standardUserDefaults().boolForKey(kVideoEnabled) {
                        alert.addAction(PMAlertAction(title: "Watch a video", style: .Default, action: {
                            self.showVideoAlert()
                        }))
                    }
                    
                    alert.addAction(PMAlertAction(title: "Ok", style: .Cancel))
                    let vc = self.view?.window?.rootViewController!
                    vc?.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            if node == endlessRibbon && lockedModes.contains(endlessRibbon) {
                scrollView.removeFromSuperview()
                
                let scene = GameScene(size: self.size)
                scene.scaleMode = .AspectFill
                
                self.removeAllChildren()
                self.removeFromParent()
                
                self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
            }
            
            if node == shootRibbon && lockedModes.contains(shootRibbon) == false {
                scrollView.removeFromSuperview()
                let scene = Shoot(size: self.size)
                self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
            }
            
            if node == memoryRibbon && lockedModes.contains(memoryRibbon) == false {
                scrollView.removeFromSuperview()
                let scene = Memory(size: size)
                self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
            }
            
            if node == multiplayerRibbon && lockedModes.contains(multiplayerRibbon) == false {
                scrollView .removeFromSuperview()
                let scene = MultiplayerMode(size: size)
                self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
            }
            
            if node == buildUpRibbon && lockedModes.contains(buildUpRibbon) == false {
                scrollView.removeFromSuperview()
                let scene = BuildUp(size: size)
                self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
            }
            
            if node == easyRibbon && lockedModes.contains(easyRibbon) == false {
                scrollView.removeFromSuperview()
                let scene = GameScene()
                scene.setGameMode(.Easy)
                self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
            }
            
            if node == impossibleRibbon && lockedModes.contains(impossibleRibbon) == false {
                scrollView.removeFromSuperview()
                let scene = GameScene()
                scene.setGameMode(.Impossible)
                self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
            }
        }
    }
    
    func showUnlockedAlert() {
        let alert = PMAlertController(title: "All Modes Unlocked!", description: "Thanks for purchasing! All the levels have been unlocked", image: nil, style: PMAlertControllerStyle.AlertWithBlur)
        alert.addAction(PMAlertAction(title: "Great!", style: .Default, action: {
            
        }))
    }
    
    func purchaseProduct(index: Int) {
        if Reachability.isConnectedToNetwork() {
            let product = products[index]
            Products.store.purchaseProduct(product)
        } else {
            let vc = self.view?.window?.rootViewController
            
            let alert = PMAlertController(title: NSLocalizedString("no-wifi-alert-title", comment: "alert-title-no-wifi"), description: NSLocalizedString("no-wifi-alert-message", comment: "alert-message-no-wifi"), image: nil, style: .AlertWithBlur)
            let action = PMAlertAction(title: NSLocalizedString("no-wifi-alert-action", comment: "alert-action-no-wifi"), style: .Cancel, action: { (UIAlertAction) in
                FTLogging().FTLog("Alert")
            })
            
            alert.addAction(action)
            vc!.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    func productPurchased(notification: NSNotification) {
        let productIdentifier = notification.object as! String
        for (_, product) in products.enumerate() {
            if product.productIdentifier == productIdentifier {
                FTLogging().FTLog("product purchased with id \(productIdentifier) & \(product.productIdentifier)")
                
                if productIdentifier == Products.UnlockAllLevel {
                    unlockAllLevels()
                }
                
                break
            }
        }
    }
    
    func unlockAllLevels() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setBool(true, forKey: k.isUnlocked.buildUp)
        defaults.setBool(true, forKey: k.isUnlocked.memory)
        defaults.setBool(true, forKey: k.isUnlocked.multiplayer)
        defaults.setBool(true, forKey: k.isUnlocked.easy)
        defaults.setBool(true, forKey: k.isUnlocked.medium)
        defaults.setBool(true, forKey: k.isUnlocked.hard)
        defaults.setBool(true, forKey: k.isUnlocked.shoot)
        defaults.setBool(true, forKey: k.isUnlocked.buildUp)
        
        setupModes()
        showUnlockedAlert()
    }
    
    func rewardUser(aNotification: NSNotification) {
        if let rewardAmount = aNotification.userInfo?["rewardAmount"] as? Int{
            let currentTapped = NSUserDefaults.standardUserDefaults().integerForKey(kNumbersKey)
            let numbersTapped = rewardAmount + currentTapped
            NSUserDefaults.standardUserDefaults().setInteger(numbersTapped, forKey: kNumbersKey)
            
            numbers.text = String(currentTapped)
        }
    }
    
    func developerMode(aNotification: NSNotification) {
        if let withAllUnlocked = aNotification.userInfo?["allUnlocked"] as? Bool {
            if withAllUnlocked {
                unlockAllLevels()
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("hideBanner", object: nil)
    }
}

