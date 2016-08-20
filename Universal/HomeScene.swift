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
    let switchDemo         = UISwitch(frame:CGRectMake(75, 370, 0, 0))
    var isShowingSettings  = false
    var scaling            = [SKNode]()
    var nonScaling         = [SKNode]()

    
    // *************************************************************
    // MARK: - didMoveToView
    // *************************************************************
    
    override func didMoveToView(view: SKView) {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "sound")
        NSNotificationCenter.defaultCenter().postNotificationName("showBanner", object: nil)
        
        scaleMode = .AspectFill
        size = CGSizeMake(640, 960)
        
        setupScene()
    }
    
    func setupScene() {
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.zPosition = -10
        background.size = self.size
        addChild(background)
        
        numberTap.position = CGPointMake(CGRectGetMidX(self.frame), 739) //324 322
        numberTap.zPosition = 2
        addChild(numberTap)
        
        info.position = CGPointMake(450, numberTap.position.y + 50)
        info.zPosition = 2
        addChild(info)
        
        sound.position = CGPointMake(info.position.x - 50, info.position.y)
        sound.zPosition = 2
        scaleForNonRetinaiPad(sound, aScale: 0.4)
        addChild(sound)
        
        play.position = CGPointMake(numberTap.position.x, 335)
        play.zPosition = 2
        addChild(play)
        scaleForNonRetinaiPad(play, aScale: 0.4)
        
        favourite.position = CGPointMake(190, numberTap.position.y - 100)
        favourite.zPosition = 2
        addChild(favourite)
        
        leaderboard.position = CGPointMake(favourite.position.x + 90, favourite.position.y)
        leaderboard.zPosition = 2
        addChild(leaderboard)
        
        like.position = CGPointMake(leaderboard.position.x + 90, leaderboard.position.y)
        like.zPosition = 2
        addChild(like)
        
        settings.position = CGPointMake(like.position.x + 90, like.position.y)
        settings.zPosition = 2
        addChild(settings)
        
        removeAds.position = CGPointMake(numberTap.position.x, leaderboard.position.y - 100)
        removeAds.zPosition = 2
        scaleForNonRetinaiPad(removeAds, aScale: 0.5)
        let def = NSUserDefaults.standardUserDefaults()
        if let _ = def.objectForKey("hasRemovedAds") as? Bool { print("all ads are gone") } else { addChild(removeAds) }
        
        gameMode.position = CGPointMake(play.position.x, play.position.y - 200)
        gameMode.zPosition = 2
        addChild(gameMode)
        
        starOne.position = CGPointMake(gameMode.position.x - 150, gameMode.position.y)
        starOne.zPosition = 5
        addChild(starOne)
        
        starTwo.position = CGPointMake(gameMode.position.x + 150, gameMode.position.y)
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
        
        let increaseAction = SKAction.scaleTo(1.1, duration: 0.5)
        let decreaseAction = SKAction.scaleTo(1, duration: 0.5)
        let completeAction = SKAction.sequence([increaseAction, decreaseAction])
        let completeActions = SKAction.repeatActionForever(completeAction)
        
        let increaseActionAds = SKAction.scaleTo(0.4, duration: 0.5)
        let decreaseActionAds = SKAction.scaleTo(0.3, duration: 0.5)
        let completeActionAds = SKAction.sequence([increaseActionAds, decreaseActionAds])
        let completeActionsAds = SKAction.repeatActionForever(completeActionAds)
        
        let rotateAction = SKAction.rotateByAngle(CGFloat(M_PI*2), duration: 4)
        let rotateRepeat = SKAction.repeatActionForever(rotateAction)
        
        let rotateAction2 = SKAction.rotateByAngle(CGFloat(-M_PI*2), duration: 4)
        let rotateRepeat2 = SKAction.repeatActionForever(rotateAction2)
        
        let completeRepeatAction = SKAction.group([completeActions, rotateRepeat])
        
        starOne.runAction(rotateRepeat)
        starTwo.runAction(rotateRepeat2)
        
        let rotateAction1 = SKAction.rotateByAngle(CGFloat(-M_PI*2), duration: 4)
        let rotateRepeat1 = SKAction.repeatActionForever(rotateAction1)
        let completeRepeatAction1 = SKAction.group([completeActions, rotateRepeat1])
        
        favourite.runAction(completeRepeatAction)
        leaderboard.runAction(completeRepeatAction1)
        like.runAction(completeRepeatAction)
        settings.runAction(completeRepeatAction1)
        
        actionsArray.append(completeAction)
        actionsArray.append(completeRepeatAction1)
        actionsArray.append(completeActions)
        actionsArray.append(completeActionsAds)
        
        if !UIScreen.mainScreen().isRetina() {
            removeAds.runAction(completeActionsAds)
        } else {
            removeAds.runAction(completeActions)
        }
        
        gameMode.runAction(completeActions)
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "gameMode")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.productPurchased), name: IAPHelperProductPurchasedNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setSceneEndless), name: "sceneSet", object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(productCancelled), name: "cancelled", object: nil)
        
        products = []
        Products.store.requestProductsWithCompletionHandler { (success, products) in
            if success {
                self.products = products
            }
        }
        
        if !UIScreen.mainScreen().isRetina() {
            for node in scaling {
                if node == sound {
                    node.runAction(SKAction.scaleTo(0.35, duration: 3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2))
                } else {
                    node.runAction(SKAction.scaleTo(0.4, duration: 3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2))
                }
            }
            
            for node in nonScaling {
                node.runAction(SKAction.scaleTo(1, duration: 3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2))
            }
        } else {
            for node in children {
                node.runAction(SKAction.scaleTo(1, duration: 3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2))
            }
        }
    }
    
    func showSettings() {
        let darkBG = SKSpriteNode(imageNamed: "background")
        darkBG.alpha = 0.95
        darkBG.zPosition = 12
        darkBG.size = self.size
        darkBG.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        darkBG.name = "darkBG"
        addChild(darkBG)
        
        for action in actionsArray {
            action.speed = 0
        }
        
        settingsText.name = "settingsText"
        settingsText.text = NSLocalizedString("settings", comment: "settings-title")
        settingsText.fontSize = 75
        settingsText.fontColor = UIColor.whiteColor()
        settingsText.zPosition = darkBG.zPosition + 1
        settingsText.horizontalAlignmentMode = .Center
        settingsText.verticalAlignmentMode = .Baseline
        settingsText.position = CGPointMake(CGRectGetMidX(self.frame), 700)
        addChild(settingsText)
        
        exit.name = "exit"
        exit.zPosition = settingsText.zPosition
        exit.position = CGPointMake(100, 900)
        addChild(exit)
        
        sound = SKSpriteNode(texture: soundOnTexture)
        sound.position = CGPointMake(settingsText.position.x - 120, settingsText.position.y - 90)
        sound.zPosition = exit.zPosition
        addChild(sound)
        
        let soundText = SKLabelNode(fontNamed: "Montserrat-Regular")
        soundText.name = "sound-text"
        soundText.text = NSLocalizedString("sound-on", comment: "sound-on")
        soundText.fontSize = 35
        soundText.horizontalAlignmentMode = .Center
        soundText.verticalAlignmentMode = .Baseline
        soundText.position = CGPointMake(sound.position.x + 130, sound.position.y - 10)
        soundText.zPosition = sound.zPosition
        soundText.fontColor = UIColor.whiteColor()
        addChild(soundText)
        
        restorePurchases.position = CGPointMake(sound.position.x, sound.position.y - 100)
        restorePurchases.zPosition = soundText.zPosition
        addChild(restorePurchases)
        
        let restoreLabel = SKLabelNode(fontNamed: "Montserrat-Regular")
        restoreLabel.name = "restoreLabel"
        restoreLabel.text = NSLocalizedString("restore", comment: "restore-purchases")
        restoreLabel.fontSize = 35
        restoreLabel.horizontalAlignmentMode = .Center
        restoreLabel.verticalAlignmentMode = .Baseline
        restoreLabel.position = CGPointMake(restorePurchases.position.x + 130, restorePurchases.position.y)
        restoreLabel.zPosition = restorePurchases.zPosition
        restoreLabel.fontColor = UIColor.whiteColor()
        addChild(restoreLabel)
        
        let restoreLabel2 = SKLabelNode(fontNamed: "Montserrat-Regular")
        restoreLabel2.name = "restore-two"
        restoreLabel2.text = NSLocalizedString("purchases", comment: "purchase-restore")
        restoreLabel2.fontSize = 35
        restoreLabel2.horizontalAlignmentMode = .Center
        restoreLabel2.verticalAlignmentMode = .Baseline
        restoreLabel2.position = CGPointMake(restorePurchases.position.x + 130, restoreLabel.position.y - 30)
        restoreLabel2.zPosition = restorePurchases.zPosition
        restoreLabel2.fontColor = UIColor.whiteColor()
        addChild(restoreLabel2)
        
        help.position = CGPointMake(restorePurchases.position.x, restorePurchases.position.y - 100)
        help.zPosition = restorePurchases.zPosition
        addChild(help)
        
        let helpLabel = SKLabelNode(fontNamed: "Montserrat-Regular")
        helpLabel.name = "help-label"
        helpLabel.text = NSLocalizedString("how-to-play", comment: "help")
        helpLabel.fontSize = 35
        helpLabel.horizontalAlignmentMode = .Center
        helpLabel.verticalAlignmentMode = .Baseline
        helpLabel.position = CGPointMake(help.position.x + 150, help.position.y - 10)
        helpLabel.zPosition = help.zPosition
        helpLabel.fontColor = UIColor.whiteColor()
        addChild(helpLabel)
        
        let darkGrey = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        let lightGrey = UIColor(red: 110/255.0, green: 107/255.0, blue: 107/255.0, alpha: 1)
        
        switchDemo.on = true
        switchDemo.setOn(true, animated: false)
        switchDemo.addTarget(self, action: #selector(HomeScene.switchValueDidChange(_:)), forControlEvents: .ValueChanged)
        switchDemo.onTintColor = darkGrey
        switchDemo.thumbTintColor = lightGrey
        self.view!.addSubview(switchDemo)
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n \(help.position)")
        
        let recordLabel = SKLabelNode(fontNamed: "Montserrat-Regular")
        recordLabel.fontSize = 35
        recordLabel.fontColor = UIColor.whiteColor()
        recordLabel.text = NSLocalizedString("record", comment: "record-gameplay")
        recordLabel.name = "record-label"
        recordLabel.position = CGPointMake(help.position.x + 150, help.position.y - 110)
        recordLabel.zPosition = helpLabel.zPosition
        recordLabel.horizontalAlignmentMode = .Center
        recordLabel.verticalAlignmentMode = .Baseline
        addChild(recordLabel)
        
        let recordLabel2 = SKLabelNode(fontNamed: "Montserrat-Regular")
        recordLabel2.fontSize = 35
        recordLabel2.fontColor = UIColor.whiteColor()
        recordLabel2.text = NSLocalizedString("gameplay", comment: "gameplay-record")
        recordLabel2.name = "gameplay-label"
        recordLabel2.position = CGPointMake(help.position.x + 150, recordLabel.position.y - 30)
        recordLabel2.zPosition = helpLabel.zPosition
        recordLabel2.horizontalAlignmentMode = .Center
        recordLabel2.verticalAlignmentMode = .Baseline
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
    
    func switchValueDidChange(sender: UISwitch) {
        if sender.on == true {
            NSNotificationCenter.defaultCenter().postNotificationName(k.NotificationCenter.RecordGameplay, object: nil, userInfo: ["isOn" : true])
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(k.NotificationCenter.RecordGameplay, object: nil, userInfo: ["isOn" : false])
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
    
    func scaleForNonRetinaiPad(node : SKSpriteNode, aScale : CGFloat) {
        if !UIScreen.mainScreen().isRetina() {
            node.setScale(aScale)
        }
    }
    
    // *************************************************************
    // MARK: - In App Purchases
    // *************************************************************
    
    func restoreTapped() {
        if Reachability.isConnectedToNetwork() {
            Products.store.restoreCompletedTransactions()
        } else {
            let vc = self.view?.window?.rootViewController
            
            let alert = UIAlertController(title: NSLocalizedString("no-wifi-alert-title", comment: "alert-title-no-wifi"), message: NSLocalizedString("no-wifi-alert-message", comment: "alert-message-no-wifi"), preferredStyle: .Alert)
            let action = UIAlertAction(title: NSLocalizedString("no-wifi-alert-action", comment: "alert-action-no-wifi"), style: .Cancel, handler: { (UIAlertAction) in
                FTLogging().FTLog("Alert")
            })
            
            alert.addAction(action)
            vc!.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    func purchaseProduct(index: Int) {
        if Reachability.isConnectedToNetwork() {
            let product = products[index]
            Products.store.purchaseProduct(product)
        } else {
            let vc = self.view?.window?.rootViewController
            
            let alert = UIAlertController(title: NSLocalizedString("no-wifi-alert-title", comment: "alert-title-no-wifi"), message: NSLocalizedString("no-wifi-alert-message", comment: "alert-message-no-wifi"), preferredStyle: .Alert)
            let action = UIAlertAction(title: NSLocalizedString("no-wifi-alert-action", comment: "alert-action-no-wifi"), style: .Cancel, handler: { (UIAlertAction) in
                FTLogging().FTLog("Alert")
            })
            
            alert.addAction(action)
            vc!.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    func productPurchased(notification: NSNotification) {
        let productIdentifier = notification.object as! String
        MBProgressHUD.hideAllHUDsForView(self.view!, animated: true)
        for (_, product) in products.enumerate() {
            if product.productIdentifier == productIdentifier {
                FTLogging().FTLog("product purchased with id \(productIdentifier) & \(product.productIdentifier)")
                if productIdentifier == Products.RemoveAds {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(true, forKey: "hasRemovedAds")
                    removeAds.runAction(SKAction.fadeAlphaTo(0, duration: 2), completion: {
                        self.removeAds.removeFromParent()
                    })
                }
                break
            }
        }
    }
    
    // *************************************************************
    // MARK: - User Interaction
    // *************************************************************
    
    override func userInteractionBegan(location: CGPoint) {
        if isShowingSettings {
            if restorePurchases.containsPoint(location) {
                print("Restore Purchases")
                
                _ = UIAlertAction(title: NSLocalizedString("restore-loading-view-title", comment: "restore-view-title"), style: .Default, handler: { (UIAlertAction) in
                    let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
                    loadingNotification.mode = .Indeterminate
                    loadingNotification.labelText = NSLocalizedString("restore-loading", comment: "restore-loading")
                    loadingNotification.userInteractionEnabled = false
                    
                    self.restoreTapped()
                })
                
            };
            
            if exit.containsPoint(location) {
                clearSettings()
            };
            
            if help.containsPoint(location) {
                let tutorialScene = TutorialScene()
                self.view?.presentScene(tutorialScene, transition: SKTransition.crossFadeWithDuration(1))
            };
            
            if sound.containsPoint(location) {
                FTLogging().FTLog("sound")
                sound.runAction(k.Sounds.blopAction1)
                
                let scoreAction = SKAction.scaleTo(1.25, duration: 0.2)
                let revertAction = SKAction.scaleTo(1, duration: 0.2)
                let completeAction = SKAction.sequence([scoreAction, revertAction])
                
                let touchSound = NSUserDefaults.standardUserDefaults().integerForKey("sound")
                
                if touchSound == 0 {
                    NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "sound")
                    NSNotificationCenter.defaultCenter().postNotificationName("stopMusic", object: nil)
                    
                    let soundLabel = self.childNodeWithName("sound-text") as! SKLabelNode
                    soundLabel.runAction(completeAction)
                    soundLabel.text = NSLocalizedString("sound-off", comment: "sound-off")
                    
                };
                
                if touchSound == 1 {
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "sound")
                    NSNotificationCenter.defaultCenter().postNotificationName("playMusic", object: nil)
                    
                    let soundLabel = self.childNodeWithName("sound-text") as! SKLabelNode
                    soundLabel.runAction(completeAction)
                    soundLabel.text = NSLocalizedString("sound-on", comment: "sound-on")
                }
                
            }
            
        } else {
            if info.containsPoint(location) {
                let tutorialScene = TutorialScene()
                self.view?.presentScene(tutorialScene, transition: SKTransition.crossFadeWithDuration(1))
                
            };
            
            if play.containsPoint(location) {
                play.runAction(k.Sounds.blopAction1)
                NSNotificationCenter.defaultCenter().postNotificationName("hideBanner", object: nil)
                
                if NSUserDefaults.isFirstLaunch() {
                    let tutorialScene = TutorialScene()
                    self.view?.presentScene(tutorialScene, transition: SKTransition.crossFadeWithDuration(1))
                } else {
                    let gameScene = GameScene()
                    self.view?.presentScene(gameScene, transition: SKTransition.fadeWithColor(UIColor(rgba: "#434343"), duration: 1))
                }
            }
            
            if gameMode.containsPoint(location) {
                
                var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
                visualEffectView.frame = view!.bounds
                self.view!.addSubview(visualEffectView)
                
                let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
                loadingNotification.mode = .Indeterminate
                loadingNotification.label.text = "Loading"
                loadingNotification.userInteractionEnabled = false
                
                let atlas1 = SKTextureAtlas(named: "Endless")
                let atlas2 = SKTextureAtlas(named: "Build-Up")
                let atlas3 = SKTextureAtlas(named: "Memory")
                let atlas4 = SKTextureAtlas(named: "Shoot")
                
                SKTextureAtlas.preloadTextureAtlases([atlas1, atlas2, atlas3, atlas4], withCompletionHandler: {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.removeFromParent()
                        self.removeAllActions()
                        self.removeAllChildren()
                        
                        visualEffectView.removeFromSuperview()
                        MBProgressHUD.hideAllHUDsForView(self.view!, animated: true)
                        
                        let gameModes = GameModes()
                        self.view?.presentScene(gameModes, transition: SKTransition.fadeWithColor(UIColor(rgba: "#434343"), duration: 1))
                        
                    })
                    
                })
            }
            
            if like.containsPoint(location) {
                SocialNetwork.Facebook.openPage()
            }
            
            if favourite.containsPoint(location) {
                let iTunesBaseUrl = "number-tap!/id1097322101?ls=1&mt=8"
                let url = NSURL(string: "itms://itunes.apple.com/us/app/" + iTunesBaseUrl)
                
                if UIApplication.sharedApplication().canOpenURL(url!) {
                    UIApplication.sharedApplication().openURL(url!)
                } else {
                    UIApplication.sharedApplication().openURL(NSURL(string: "https://facebook.com/831944953601016")!)
                }
            }
            
            if leaderboard.containsPoint(location) {
                GCHelper.sharedGameKitHelper.showGameCenter((view?.window?.rootViewController)!, viewState: .Leaderboards)
            };
            
            if settings.containsPoint(location) {
                showSettings()
            };
            
            if removeAds.containsPoint(location) {
                removeAds.runAction(k.Sounds.blopAction1)
                
                purchaseProduct(0)
            }
            
            if sound.containsPoint(location) {
                sound.runAction(k.Sounds.blopAction1)
                let touchSound = NSUserDefaults.standardUserDefaults().integerForKey("sound")
                
                if touchSound == 0 {
                    NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "sound")
                    NSNotificationCenter.defaultCenter().postNotificationName("stopMusic", object: nil)
                };
                
                if touchSound == 1 {
                    NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "sound")
                    NSNotificationCenter.defaultCenter().postNotificationName("playMusic", object: nil)
                }
            }
        }
    }
    
    override func userInteractionMoved(location: CGPoint) {
        // touch/mouse moved
    }
    
    override func userInteractionEnded(location: CGPoint) {
        
    }
    
}
