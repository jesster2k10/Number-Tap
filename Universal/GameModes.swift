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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
    let endlessRibbon             = Ribbon(ribbonType: .endless, bodyColour: .Purple, dotsColour: .Purple, text: "")
    let shootRibbon               = Ribbon(ribbonType: .shoot, bodyColour: .Red, dotsColour: .Red, text: "")
    let memoryRibbon              = Ribbon(ribbonType: .memory, bodyColour: .Turqouise, dotsColour: .Turqouise, text: "")
    let multiplayerRibbon         = Ribbon(ribbonType: .multiplayer, bodyColour: .DarkBlue, dotsColour: .DarkBlue, text: "")
    let buildUpRibbon             = Ribbon(ribbonType: .build, bodyColour: .Green, dotsColour: .Green, text: "")
    let easyRibbon                = Ribbon(ribbonType: .easy, bodyColour: .LightBlue, dotsColour: .LightBlue, text: "EASY")
    let mediumRibbon              = Ribbon(ribbonType: .medium, bodyColour: .Orange, dotsColour: .Orange, text: "MEDIUM")
    let impossibleRibbon          = Ribbon(ribbonType: .hard, bodyColour: .LightRed, dotsColour: .LightRed, text: "HARD")
    
    var ribbons                   = [Ribbon]()
    var nodesTouched: [AnyObject] = []
    var lockedModes               = [Ribbon]()
    var products                  = [SKProduct]()
    var titlesArray               = [SKLabelNode]()
    
    //TODO: Create new leaderboards for the different game modes
    override func didMove(to view: SKView) {
        scaleMode = .aspectFill
        size = CGSize(width: 640, height: 960)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showBanner"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rewardUser(_:)), name: NSNotification.Name(rawValue: "videoRewarded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(developerMode), name: NSNotification.Name(rawValue: "DeveloperMode"), object: nil)
        
        products = []
        Products.store.requestProducts{success, products in
            if success {
                self.products = products!
            }
        }
        
        if !UIScreen.main.isRetina() {
            scrollView = SKScrollView(frame: CGRect(x: 0, y: 0, width: 10240, height: self.frame.size.height - 250), moveableNode: moveableNode, scrollDirection: .vertical, scene: self)
        } else {
            scrollView = SKScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - 250), moveableNode: moveableNode, scrollDirection: .vertical, scene: self)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height * 1.5) // makes it 3 times the height
        view.addSubview(scrollView)
        addChild(moveableNode)
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = self.size
        background.zPosition = -1
        addChild(background)
        
        if !UIScreen.main.isRetina() {
            titleBG.position = CGPoint(x: self.frame.midX, y: 860)
        } else {
            titleBG.position = CGPoint(x: self.frame.midX, y: 920)
        }
        titleBG.setScale(1.3)
        
        gameModes.text = NSLocalizedString("game-modes", comment: "Game Modes")
        gameModes.horizontalAlignmentMode = .center
        gameModes.verticalAlignmentMode = .center
        gameModes.zPosition = 10
        gameModes.fontSize = 50
        
        titleBG.addChild(gameModes)
        
        let gameModesShadow = SKLabelNode(fontNamed: k.Montserrat.SemiBold)
        gameModesShadow.color = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        gameModesShadow.alpha = 0.21
        gameModesShadow.position = CGPoint(x: gameModes.position.x, y: gameModes.position.y - 3)
        gameModesShadow.horizontalAlignmentMode = .center
        gameModesShadow.verticalAlignmentMode = .center
        gameModesShadow.zPosition = 10
        gameModesShadow.fontSize = 65
        titleBG.addChild(gameModesShadow)
        titleBG.zPosition = moveableNode.zPosition + 1000
        addChild(titleBG)
        
        if !UIScreen.main.isRetina() {
            darkStrip.xScale = 2.5
            darkStrip.position = CGPoint(x: titleBG.position.x, y: titleBG.position.y - 100)
            
        } else {
            darkStrip.xScale = 2.5
            darkStrip.position = CGPoint(x: titleBG.position.x, y: titleBG.position.y - 120)
        }
        moveableNode.addChild(darkStrip)
        
        numbersTapped.position = CGPoint(x: darkStrip.position.x - 140, y: darkStrip.position.y - 10)
        numbersTapped.text = "Numbers Tapped:"
        numbersTapped.fontSize = 24
        numbersTapped.fontColor = UIColor.white
        numbersTapped.horizontalAlignmentMode = .center
        numbersTapped.zPosition = 333
        moveableNode.addChild(numbersTapped)
        
        numbers.position = CGPoint(x: numbersTapped.position.x + 125, y: numbersTapped.position.y + 1)
        numbers.text = "\(UserDefaults.standard.integer(forKey: kNumbersKey))"
        numbers.fontColor = numbersTapped.fontColor
        numbers.fontSize = numbersTapped.fontSize - 4
        numbers.horizontalAlignmentMode = .center
        numbers.zPosition = 333
        moveableNode.addChild(numbers)
        
        leaderboard.position = CGPoint(x: darkStrip.position.x + 180, y: darkStrip.position.y)
        leaderboard.zPosition = 33
        leaderboard.name = "leaderboard"
        moveableNode.addChild(leaderboard)
        
        home.position = CGPoint(x: leaderboard.position.x - 72, y: leaderboard.position.y)
        home.zPosition = leaderboard.zPosition
        home.setScale(1.5)
        home.name = "home"
        moveableNode.addChild(home)
        
        endlessRibbon.position = CGPoint(x: 203, y: 651)
        endlessRibbon.setScale(1.5)
        endlessRibbon.setSuperScene(self)
        moveableNode.addChild(endlessRibbon)
        
        easyRibbon.position = CGPoint(x: endlessRibbon.position.x, y: endlessRibbon.position.y - 150)
        easyRibbon.setScale(1.5)
        easyRibbon.setSuperScene(self)
        moveableNode.addChild(easyRibbon)
        
        impossibleRibbon.position = CGPoint(x: easyRibbon.position.x, y: easyRibbon.position.y - 150)
        impossibleRibbon.setScale(1.5)
        impossibleRibbon.setSuperScene(self)
        moveableNode.addChild(impossibleRibbon)
        
        shootRibbon.position = CGPoint(x: 203, y: impossibleRibbon.position.y - 150)
        shootRibbon.setScale(1.5)
        shootRibbon.setSuperScene(self)
        moveableNode.addChild(shootRibbon)
        
        memoryRibbon.position = CGPoint(x: shootRibbon.position.x, y: shootRibbon.position.y - 150)
        memoryRibbon.setScale(1.5)
        memoryRibbon.setSuperScene(self)
        moveableNode.addChild(memoryRibbon)
        
        buildUpRibbon.position = CGPoint(x: memoryRibbon.position.x, y: memoryRibbon.position.y - 150)
        buildUpRibbon.setScale(1.5)
        buildUpRibbon.setSuperScene(self)
        moveableNode.addChild(buildUpRibbon)
        
        multiplayerRibbon.position = CGPoint(x: buildUpRibbon.position.x, y: buildUpRibbon.position.y - 150)
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
        
        if UserDefaults.keyAlreadyExists(kNumbersKey) {
            let tapped = UserDefaults.standard.integer(forKey: kNumbersKey)
            let checkArray = [k.numbersToUnlock.buildUp, k.numbersToUnlock.easy, k.numbersToUnlock.medium, k.numbersToUnlock.hard, k.numbersToUnlock.shoot, k.numbersToUnlock.memory, k.numbersToUnlock.multiplayer, k.numbersToUnlock.endless, k.numbersToUnlock.shoot]
            
            for number in checkArray {
                if tapped == number {
                    switch number {
                    case k.numbersToUnlock.buildUp:
                        UserDefaults.standard.set(true, forKey: k.isUnlocked.buildUp)
                    case k.numbersToUnlock.easy:
                        UserDefaults.standard.set(true, forKey: k.isUnlocked.easy)
                    case k.numbersToUnlock.medium:
                        UserDefaults.standard.set(true, forKey: k.isUnlocked.medium)
                    case k.numbersToUnlock.hard:
                        UserDefaults.standard.set(true, forKey: k.isUnlocked.hard)
                    case k.numbersToUnlock.shoot:
                        UserDefaults.standard.set(true, forKey: k.isUnlocked.shoot)
                    case k.numbersToUnlock.memory:
                        UserDefaults.standard.set(true, forKey: k.isUnlocked.memory)
                    case k.numbersToUnlock.endless:
                        UserDefaults.standard.set(true, forKey: k.isUnlocked.endless)
                    case k.numbersToUnlock.multiplayer:
                        UserDefaults.standard.set(true, forKey: k.isUnlocked.multiplayer)
                    default:
                        break;
                    }
                    
                    print("New level is unlocked")
                    setupModes()
                }
            }
        }
        
        if !UserDefaults.keyAlreadyExists(kVideoEnabled) {
            UserDefaults.standard.set(true, forKey: kVideoEnabled)
        }
        
    }
    
    func setupModes() {
        var tapped = 0
        
        if UserDefaults.keyAlreadyExists(kNumbersKey) {
            tapped = UserDefaults.standard.integer(forKey: kNumbersKey)
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
            setupText(endlessRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: UserDefaults.standard.highScore)
            endlessRibbon.unlocked(GameMode.endless, text: "")
        } else {
            setupText(endlessRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.endless, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.easy) {
            setupText(easyRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: UserDefaults.standard.highScore)
            easyRibbon.unlocked(GameMode.easy, text: "EASY")
        } else {
            setupText(easyRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.easy, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.hard) {
            setupText(impossibleRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: UserDefaults.standard.highScore)
            impossibleRibbon.unlocked(GameMode.hard, text: "IMPOSSIBLE")
        } else {
            setupText(impossibleRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.hard, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.shoot) {
            setupText(shootRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: nil)
            shootRibbon.unlocked(GameMode.shoot, text: "")
        } else {
            setupText(shootRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.shoot, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.memory) {
            setupText(memoryRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: nil)
            memoryRibbon.unlocked(GameMode.memory, text: "")
        } else {
            setupText(memoryRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.memory, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.multiplayer) {
            setupText(multiplayerRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: nil)
            multiplayerRibbon.unlocked(GameMode.multiplayer, text: "")
        } else {
            setupText(multiplayerRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.multiplayer, currentTapped: tapped, bestScore: nil)
        }
        
        if modeIsUnlocked(k.isUnlocked.buildUp) {
            setupText(buildUpRibbon, unlocked: true, numbersNeededToUnlock: nil, currentTapped: nil, bestScore: nil)
            buildUpRibbon.unlocked(GameMode.build, text: "")
        } else {
            setupText(buildUpRibbon, unlocked: false, numbersNeededToUnlock: k.numbersToUnlock.buildUp, currentTapped: tapped, bestScore: nil)
        }
    }
    
    func modeIsUnlocked(_ mode: String) -> Bool {
        if !UserDefaults.keyAlreadyExists(mode) {
            return false
        }
        
        return true
    }
    
    //TODO: Make sure nodes are being added to the locked array
    func setupText(_ ribbon: Ribbon, unlocked: Bool = false, numbersNeededToUnlock: Int?, currentTapped: Int?, bestScore: Int? = 0) {
        if numbersNeededToUnlock != nil && currentTapped != nil {
            ribbon.setNumbersLeft(numbersNeededToUnlock! - currentTapped!)
        }
        let topLabel = SKLabelNode(fontNamed: k.Montserrat.SemiBold)
        let bottomLabelOne = SKLabelNode(fontNamed: k.Montserrat.Light)
        let bottomLabelTwo = SKLabelNode(fontNamed: k.Montserrat.Light)
        
        topLabel.position = CGPoint(x: ribbon.position.x + 300, y: ribbon.position.y + 10)
        topLabel.horizontalAlignmentMode = .center
        topLabel.verticalAlignmentMode = .baseline
        topLabel.fontSize = 25
        topLabel.fontColor = UIColor.white
        topLabel.name = "top-label"
        moveableNode.addChild(topLabel)
        
        bottomLabelOne.position = CGPoint(x: topLabel.position.x, y: topLabel.position.y - 30)
        bottomLabelOne.horizontalAlignmentMode = topLabel.horizontalAlignmentMode
        bottomLabelOne.verticalAlignmentMode = topLabel.verticalAlignmentMode
        bottomLabelOne.fontSize = topLabel.fontSize
        bottomLabelOne.fontColor = topLabel.fontColor
        bottomLabelOne.name = "bottom-label-1"
        moveableNode.addChild(bottomLabelOne)
        
        bottomLabelTwo.position = CGPoint(x: bottomLabelOne.position.x, y: bottomLabelOne.position.y - 28)
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
        let alert = PMAlertController(title: "Watch a video", description: "Want to get 50 taps by watching a short video?", image: nil, style: .alert)
        alert.addAction(PMAlertAction(title: "Yes!", style: .default, action: {
            //TODO: Show rewarded video
            //TODO: Don't Allow them do it again for the day
            if Supersonic.sharedInstance().isAdAvailable() {
                print("Showing thingh")
                Supersonic.sharedInstance().showRV(withPlacementName: "Game_Modes")
                
                let date = NSDate()
                let networkDate = NSDate.network()
                
                if Date.daysBetweenThisDate(date as Date, andThisDate: networkDate!) < 1 {
                    UserDefaults.standard.set(false, forKey: kVideoEnabled)
                } else if Date.daysBetweenThisDate(date as Date, andThisDate: networkDate!) > 1  {
                    UserDefaults.standard.set(true, forKey: kVideoEnabled)
                }
            }
        }))
        
        alert.addAction(PMAlertAction(title: "No", style: .cancel, action: {
            print("cancel")
            //TODO: Allow them do it again for the day
        }))
        
        let vc = self.view?.window?.rootViewController!
        Timer.after(0.01) {
            vc?.present(alert, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)
            let node = atPoint(location)
            
            if node == home { // or check for spriteName  ->  if node.name == "SpriteName"
                scrollView.removeFromSuperview()
                let scene = HomeScene()
                self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
            
            if node == leaderboard {
                scrollView.removeFromSuperview()
                GCHelper.sharedGameKitHelper.showGameCenter((view?.window?.rootViewController)!, viewState: .leaderboards)
            }
            
            for mode in lockedModes {
                if node == mode {
                    let alert = PMAlertController(title: "Locked Game Mode", description: "This mode is locked! You have to tap another \(mode.numbersLeftToUnlock!) numbers to unlock this mode. You must keep on tapping!", image: nil, style: .walkthrough)
                    alert.addAction(PMAlertAction(title: "Unlock all modes", style: .default, action: {
                        self.purchaseProduct(1)
                    }))
                    
                    alert.addAction(PMAlertAction(title: "Unlock this mode", style: .default, action: {
                        //TODO: Set up IAP to unlock all of the levels.
                    }))
                    
                    if (UserDefaults.standard.bool(forKey: kVideoEnabled) != nil) {
                        alert.addAction(PMAlertAction(title: "Watch a video", style: .default, action: {
                            self.showVideoAlert()
                        }))
                    }
                    
                    alert.addAction(PMAlertAction(title: "Ok", style: .cancel))
                    let vc = self.view?.window?.rootViewController!
                    vc?.present(alert, animated: true, completion: nil)
                }
            }
            
            if node == endlessRibbon && lockedModes.contains(endlessRibbon) {
                scrollView.removeFromSuperview()
                
                let scene = GameScene(size: self.size)
                scene.scaleMode = .aspectFill
                
                self.removeAllChildren()
                self.removeFromParent()
                
                self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
            
            if node == shootRibbon && lockedModes.contains(shootRibbon) == false {
                scrollView.removeFromSuperview()
                let scene = Shoot(size: self.size)
                self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
            
            if node == memoryRibbon && lockedModes.contains(memoryRibbon) == false {
                scrollView.removeFromSuperview()
                let scene = Memory(size: size)
                self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
            
            if node == multiplayerRibbon && lockedModes.contains(multiplayerRibbon) == false {
                scrollView .removeFromSuperview()
                let scene = MultiplayerMode(size: size)
                self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
            
            if node == buildUpRibbon && lockedModes.contains(buildUpRibbon) == false {
                scrollView.removeFromSuperview()
                let scene = BuildUp(size: size)
                self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
            
            if node == easyRibbon && lockedModes.contains(easyRibbon) == false {
                scrollView.removeFromSuperview()
                let scene = GameScene()
                scene.setGameMode(.Easy)
                self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
            
            if node == impossibleRibbon && lockedModes.contains(impossibleRibbon) == false {
                scrollView.removeFromSuperview()
                let scene = GameScene()
                scene.setGameMode(.Impossible)
                self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
        }
    }
    
    func showUnlockedAlert() {
        let alert = PMAlertController(title: "All Modes Unlocked!", description: "Thanks for purchasing! All the levels have been unlocked", image: nil, style: PMAlertControllerStyle.alertWithBlur)
        alert.addAction(PMAlertAction(title: "Great!", style: .default, action: {
            
        }))
    }
    
    func purchaseProduct(_ index: Int) {
        if Reachability.isConnectedToNetwork() {
            let product = products[index]
            Products.store.buyProduct(product)
        } else {
            let vc = self.view?.window?.rootViewController
            
            let alert = PMAlertController(title: NSLocalizedString("no-wifi-alert-title", comment: "alert-title-no-wifi"), description: NSLocalizedString("no-wifi-alert-message", comment: "alert-message-no-wifi"), image: nil, style: .alertWithBlur)
            let action = PMAlertAction(title: NSLocalizedString("no-wifi-alert-action", comment: "alert-action-no-wifi"), style: .cancel, action: { (UIAlertAction) in
                FTLogging().FTLog("Alert")
            })
            
            alert.addAction(action)
            vc!.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func productPurchased(_ notification: Notification) {
        let productIdentifier = notification.object as! String
        for (_, product) in products.enumerated() {
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
        let defaults = UserDefaults.standard
        
        defaults.set(true, forKey: k.isUnlocked.buildUp)
        defaults.set(true, forKey: k.isUnlocked.memory)
        defaults.set(true, forKey: k.isUnlocked.multiplayer)
        defaults.set(true, forKey: k.isUnlocked.easy)
        defaults.set(true, forKey: k.isUnlocked.medium)
        defaults.set(true, forKey: k.isUnlocked.hard)
        defaults.set(true, forKey: k.isUnlocked.shoot)
        defaults.set(true, forKey: k.isUnlocked.buildUp)
        
        setupModes()
        showUnlockedAlert()
    }
    
    func rewardUser(_ aNotification: Notification) {
        if let rewardAmount = (aNotification as NSNotification).userInfo?["rewardAmount"] as? Int{
            let currentTapped = UserDefaults.standard.integer(forKey: kNumbersKey)
            let numbersTapped = rewardAmount + currentTapped
            UserDefaults.standard.set(numbersTapped, forKey: kNumbersKey)
            
            numbers.text = "\(currentTapped)"
        }
    }
    
    func developerMode(_ aNotification: Notification) {
        if let withAllUnlocked = (aNotification as NSNotification).userInfo?["allUnlocked"] as? Bool {
            if withAllUnlocked {
                unlockAllLevels()
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "hideBanner"), object: nil)
    }
}

