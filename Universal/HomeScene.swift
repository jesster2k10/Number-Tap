//
//  GameScene.swift
//  Game Template tvOS/iOS/OSX
//
//  Created by Matthew Fecher on 12/12/15.
//  Copyright (c) 2015 Denver Swift Heads. All rights reserved.
//

import SpriteKit
import StoreKit
import MBProgressHUD

class HomeScene: InitScene {
    
    let background         = SKSpriteNode(imageNamed: "background")
    let play               = SKSpriteNode(imageNamed: "play")
    let numberTap          = SKSpriteNode(imageNamed: "number tap")
    let favourite          = SKSpriteNode(imageNamed: "favourite")
    let like               = SKSpriteNode(imageNamed: "like")
    let leaderboard        = SKSpriteNode(imageNamed: "leaderboard")
    let removeAds          = SKSpriteNode(imageNamed: "remove-ads-long")
    let gameMode           = SKSpriteNode(imageNamed: "banner")
    let starOne            = SKSpriteNode(imageNamed: "star")
    let starTwo            = SKSpriteNode(imageNamed: "star")
    var sound              = SKSpriteNode(imageNamed: "sound")
    let info               = SKSpriteNode(imageNamed: "info")
    let settings           = SKSpriteNode(imageNamed: "settings")
    
    //MARK : Settings
    let settingsText       = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let help               = SKSpriteNode(imageNamed: "how-to-play")
    let restorePurchases   = SKSpriteNode(imageNamed: "restorePurchases")
    let soundOnTexture     = SKTexture(imageNamed: "sound-on")
    let soundOfTexture     = SKTexture(imageNamed: "sound-off")
    let soundSettings      = SKSpriteNode()
    let exit               = SKSpriteNode(imageNamed: "exit")
    var products           = [SKProduct]()
    var settingsArray      = [SKNode]()
    var actionsArray       = [SKAction]()
    let switchDemo         = UISwitch(frame:CGRect(x: 75, y: 370, width: 0, height: 0))
    var isShowingSettings  = false
    var scaling            = [SKNode]()
    var nonScaling         = [SKNode]()

    
    // *************************************************************
    // MARK: - didMoveToView
    // *************************************************************
    
    override func didMove(to view: SKView) {
        UserDefaults.standard.set(0, forKey: "sound")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showBanner"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGameMode), name: NSNotification.Name(rawValue: kPlayGameModeNotification), object: nil)
        
        scaleMode = .aspectFill
        size = CGSize(width: 640, height: 960)
        
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
        scaleForNonRetinaiPad(sound, aScale: 0.4)
        addChild(sound)
        
        play.position = CGPoint(x: numberTap.position.x, y: 335)
        play.zPosition = 2
        addChild(play)
        scaleForNonRetinaiPad(play, aScale: 0.4)
        
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
        scaleForNonRetinaiPad(removeAds, aScale: 0.5)
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
        
        scaling.append(play)
        scaling.append(removeAds)
        scaling.append(sound)
        
        nonScaling.append(numberTap)
        nonScaling.append(info)
        nonScaling.append(favourite)
        nonScaling.append(leaderboard)
        nonScaling.append(like)
        nonScaling.append(settings)
        nonScaling.append(gameMode)
        nonScaling.append(starOne)
        nonScaling.append(starTwo)
        
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
        
        if !UIScreen.main.isRetina() {
            removeAds.run(completeActionsAds)
        } else {
            removeAds.run(completeActions)
        }
        
        gameMode.run(completeActions)
        
        UserDefaults.standard.set(0, forKey: "gameMode")
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.productPurchased), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setSceneEndless), name: "sceneSet", object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(productCancelled), name: "cancelled", object: nil)
        
        products = []
        Products.store.requestProducts{success, products in
            if success {
                self.products = products!
            }
        }
        
        if !UIScreen.main.isRetina() {
            for node in scaling {
                if node == sound {
                    node.run(SKAction.scale(to: 0.35, duration: 3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2))
                } else {
                    node.run(SKAction.scale(to: 0.4, duration: 3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2))
                }
            }
            
            for node in nonScaling {
                node.run(SKAction.scale(to: 1, duration: 3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2))
            }
        } else {
            for node in children {
                node.run(SKAction.scale(to: 1, duration: 3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2))
            }
        }
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
        settingsText.fontColor = UIColor.white
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
        soundText.fontColor = UIColor.white
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
        restoreLabel.fontColor = UIColor.white
        addChild(restoreLabel)
        
        let restoreLabel2 = SKLabelNode(fontNamed: "Montserrat-Regular")
        restoreLabel2.name = "restore-two"
        restoreLabel2.text = NSLocalizedString("purchases", comment: "purchase-restore")
        restoreLabel2.fontSize = 35
        restoreLabel2.horizontalAlignmentMode = .center
        restoreLabel2.verticalAlignmentMode = .baseline
        restoreLabel2.position = CGPoint(x: restorePurchases.position.x + 130, y: restoreLabel.position.y - 30)
        restoreLabel2.zPosition = restorePurchases.zPosition
        restoreLabel2.fontColor = UIColor.white
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
        helpLabel.fontColor = UIColor.white
        addChild(helpLabel)
        
        let darkGrey = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        let lightGrey = UIColor(red: 110/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1)
        
        switchDemo.isOn = true
        switchDemo.setOn(true, animated: false)
        switchDemo.addTarget(self, action: #selector(HomeScene.switchValueDidChange(_:)), for: .valueChanged)
        switchDemo.onTintColor = darkGrey
        switchDemo.thumbTintColor = lightGrey
        self.view!.addSubview(switchDemo)
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n \(help.position)")
        
        let recordLabel = SKLabelNode(fontNamed: "Montserrat-Regular")
        recordLabel.fontSize = 35
        recordLabel.fontColor = UIColor.white
        recordLabel.text = NSLocalizedString("record", comment: "record-gameplay")
        recordLabel.name = "record-label"
        recordLabel.position = CGPoint(x: help.position.x + 150, y: help.position.y - 110)
        recordLabel.zPosition = helpLabel.zPosition
        recordLabel.horizontalAlignmentMode = .center
        recordLabel.verticalAlignmentMode = .baseline
        addChild(recordLabel)
        
        let recordLabel2 = SKLabelNode(fontNamed: "Montserrat-Regular")
        recordLabel2.fontSize = 35
        recordLabel2.fontColor = UIColor.white
        recordLabel2.text = NSLocalizedString("gameplay", comment: "gameplay-record")
        recordLabel2.name = "gameplay-label"
        recordLabel2.position = CGPoint(x: help.position.x + 150, y: recordLabel.position.y - 30)
        recordLabel2.zPosition = helpLabel.zPosition
        recordLabel2.horizontalAlignmentMode = .center
        recordLabel2.verticalAlignmentMode = .baseline
        addChild(recordLabel2)
        
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
        settingsArray.append(recordLabel)
        settingsArray.append(recordLabel2)
        
        isShowingSettings = true
    }
    
    func switchValueDidChange(_ sender: UISwitch) {
        if sender.isOn == true {
            NotificationCenter.default.post(name: Notification.Name(rawValue: k.NotificationCenter.RecordGameplay), object: nil, userInfo: ["isOn" : true])
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: k.NotificationCenter.RecordGameplay), object: nil, userInfo: ["isOn" : false])
        }
    }
    
    func clearSettings() {
        for node in settingsArray {
            node.removeFromParent()
        }
        
        switchDemo.removeFromSuperview()
        isShowingSettings = false
        
        for action in actionsArray {
            action.speed = 1
        }
    }
    
    func scaleForNonRetinaiPad(_ node : SKSpriteNode, aScale : CGFloat) {
        if !UIScreen.main.isRetina() {
            node.setScale(aScale)
        }
    }
    
    // *************************************************************
    // MARK: - In App Purchases
    // *************************************************************
    
    func restoreTapped() {
        if Reachability.isConnectedToNetwork() {
            Products.store.restorePurchases()
        } else {
            let vc = self.view?.window?.rootViewController
            
            let alert = UIAlertController(title: NSLocalizedString("no-wifi-alert-title", comment: "alert-title-no-wifi"), message: NSLocalizedString("no-wifi-alert-message", comment: "alert-message-no-wifi"), preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("no-wifi-alert-action", comment: "alert-action-no-wifi"), style: .cancel, handler: { (UIAlertAction) in
                FTLogging().FTLog("Alert")
            })
            
            alert.addAction(action)
            vc!.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func purchaseProduct(_ index: Int) {
        if Reachability.isConnectedToNetwork() {
            let product = products[index]
            Products.store.buyProduct(product)
        } else {
            let vc = self.view?.window?.rootViewController
            
            let alert = UIAlertController(title: NSLocalizedString("no-wifi-alert-title", comment: "alert-title-no-wifi"), message: NSLocalizedString("no-wifi-alert-message", comment: "alert-message-no-wifi"), preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("no-wifi-alert-action", comment: "alert-action-no-wifi"), style: .cancel, handler: { (UIAlertAction) in
                FTLogging().FTLog("Alert")
            })
            
            alert.addAction(action)
            vc!.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func productPurchased(_ notification: Notification) {
        let productIdentifier = notification.object as! String
        MBProgressHUD.hideAllHUDs(for: self.view!, animated: true)
        for (_, product) in products.enumerated() {
            if product.productIdentifier == productIdentifier {
                FTLogging().FTLog("product purchased with id \(productIdentifier) & \(product.productIdentifier)")
                if productIdentifier == Products.RemoveAds {
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "hasRemovedAds")
                    removeAds.run(SKAction.fadeAlpha(to: 0, duration: 2), completion: {
                        self.removeAds.removeFromParent()
                    })
                }
                break
            }
        }
    }
    
    func showGameMode() {
        print("Showing Game Mode")
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = view!.bounds
        self.view!.addSubview(visualEffectView)
        
        let loadingNotification = MBProgressHUD.showAdded(to: self.view!, animated: true)
        loadingNotification.mode = .indeterminate
        loadingNotification.label.text = "Loading"
        loadingNotification.isUserInteractionEnabled = false
        
        let atlas1 = SKTextureAtlas(named: "Endless")
        let atlas2 = SKTextureAtlas(named: "Build-Up")
        let atlas3 = SKTextureAtlas(named: "Memory")
        let atlas4 = SKTextureAtlas(named: "Shoot")
        
        SKTextureAtlas.preloadTextureAtlases([atlas1, atlas2, atlas3, atlas4], withCompletionHandler: {
            DispatchQueue.main.async(execute: {
                self.removeFromParent()
                self.removeAllActions()
                self.removeAllChildren()
                
                visualEffectView.removeFromSuperview()
                MBProgressHUD.hideAllHUDs(for: self.view!, animated: true)
                
                let gameModes = GameModes()
                self.view?.presentScene(gameModes, transition: SKTransition.fade(with: UIColor(rgba: "#434343"), duration: 1))
                
            })
            
        })
    }
    
    // *************************************************************
    // MARK: - User Interaction
    // *************************************************************
    
    override func userInteractionBegan(_ location: CGPoint) {
        if isShowingSettings {
            if restorePurchases.contains(location) {
                print("Restore Purchases")
                
                _ = UIAlertAction(title: NSLocalizedString("restore-loading-view-title", comment: "restore-view-title"), style: .default, handler: { (UIAlertAction) in
                    let loadingNotification = MBProgressHUD.showAdded(to: self.view!, animated: true)
                    loadingNotification.mode = .indeterminate
                    loadingNotification.labelText = NSLocalizedString("restore-loading", comment: "restore-loading")
                    loadingNotification.isUserInteractionEnabled = false
                    
                    self.restoreTapped()
                })
                
            };
            
            if exit.contains(location) {
                clearSettings()
            };
            
            if help.contains(location) {
                let tutorialScene = TutorialScene()
                self.view?.presentScene(tutorialScene, transition: SKTransition.crossFade(withDuration: 1))
            };
            
            if sound.contains(location) {
                FTLogging().FTLog("sound")
                sound.run(k.Sounds.blopAction1)
                
                let scoreAction = SKAction.scale(to: 1.25, duration: 0.2)
                let revertAction = SKAction.scale(to: 1, duration: 0.2)
                let completeAction = SKAction.sequence([scoreAction, revertAction])
                
                let touchSound = UserDefaults.standard.integer(forKey: "sound")
                
                if touchSound == 0 {
                    UserDefaults.standard.set(1, forKey: "sound")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "stopMusic"), object: nil)
                    
                    let soundLabel = self.childNode(withName: "sound-text") as! SKLabelNode
                    soundLabel.run(completeAction)
                    soundLabel.text = NSLocalizedString("sound-off", comment: "sound-off")
                    
                };
                
                if touchSound == 1 {
                    UserDefaults.standard.set(0, forKey: "sound")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "playMusic"), object: nil)
                    
                    let soundLabel = self.childNode(withName: "sound-text") as! SKLabelNode
                    soundLabel.run(completeAction)
                    soundLabel.text = NSLocalizedString("sound-on", comment: "sound-on")
                }
                
            }
            
        } else {
            if info.contains(location) {
                let tutorialScene = TutorialScene()
                self.view?.presentScene(tutorialScene, transition: SKTransition.crossFade(withDuration: 1))
                
            };
            
            if play.contains(location) {
                play.run(k.Sounds.blopAction1)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "hideBanner"), object: nil)
                
                let gameScene = GameScene()
                self.view?.presentScene(gameScene, transition: SKTransition.fade(with: UIColor(rgba: "#434343"), duration: 1))
                
            }
            
            if gameMode.contains(location) {
                
                let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                visualEffectView.frame = view!.bounds
                self.view!.addSubview(visualEffectView)
                
                let loadingNotification = MBProgressHUD.showAdded(to: self.view!, animated: true)
                loadingNotification.mode = .indeterminate
                loadingNotification.label.text = "Loading"
                loadingNotification.isUserInteractionEnabled = false
                
                let atlas1 = SKTextureAtlas(named: "Endless")
                let atlas2 = SKTextureAtlas(named: "Build-Up")
                let atlas3 = SKTextureAtlas(named: "Memory")
                let atlas4 = SKTextureAtlas(named: "Shoot")
                
                SKTextureAtlas.preloadTextureAtlases([atlas1, atlas2, atlas3, atlas4], withCompletionHandler: {
                    DispatchQueue.main.async(execute: {
                        self.removeFromParent()
                        self.removeAllActions()
                        self.removeAllChildren()
                        
                        visualEffectView.removeFromSuperview()
                        MBProgressHUD.hideAllHUDs(for: self.view!, animated: true)
                        
                        let gameModes = GameModes()
                        self.view?.presentScene(gameModes, transition: SKTransition.fade(with: UIColor(rgba: "#434343"), duration: 1))
                        
                    })
                    
                })
            }
            
            if like.contains(location) {
                SocialNetwork.facebook.openPage()
            }
            
            if favourite.contains(location) {
                let iTunesBaseUrl = "number-tap!/id1097322101?ls=1&mt=8"
                let url = URL(string: "itms://itunes.apple.com/us/app/" + iTunesBaseUrl)
                
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                } else {
                    UIApplication.shared.openURL(URL(string: "https://facebook.com/831944953601016")!)
                }
            }
            
            if leaderboard.contains(location) {
                GCHelper.sharedGameKitHelper.showGameCenter((view?.window?.rootViewController)!, viewState: .leaderboards)
            };
            
            if settings.contains(location) {
                showSettings()
            };
            
            if removeAds.contains(location) {
                removeAds.run(k.Sounds.blopAction1)
                
                purchaseProduct(0)
            }
            
            if sound.contains(location) {
                sound.run(k.Sounds.blopAction1)
                let touchSound = UserDefaults.standard.integer(forKey: "sound")
                
                if touchSound == 0 {
                    UserDefaults.standard.set(1, forKey: "sound")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "stopMusic"), object: nil)
                };
                
                if touchSound == 1 {
                    UserDefaults.standard.set(0, forKey: "sound")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "playMusic"), object: nil)
                }
            }
        }
    }
    
    override func userInteractionMoved(_ location: CGPoint) {
        // touch/mouse moved
    }
    
    override func userInteractionEnded(_ location: CGPoint) {
        
    }
    
}
