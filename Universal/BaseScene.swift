//
//  GameMode.swift
//  Number Tap
//
//  Created by jesse on 05/07/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import StoreKit
import GameKit
import StoreKit
import ReplayKit
import MBProgressHUD
import Armchair

enum kGameMode {
    case kMultiplayer
    case kMemory
    case kBuildUp
    case kFollow
}

class BaseScene : SKScene {
    let background = SKSpriteNode(imageNamed: "background")
    var array = [Int]()
    var products = [SKProduct]()
    var continueArray = [SKNode]()
    var topArray = [SKNode]()
    var timerArray = [NSTimer]()
    var countdownArray = [SKNode]()
    
    var currentMode: gameMode!
    
    var counter = 10
    
    let countdown = CountdownNode(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(0, 0))
    var countdownTimer = NSTimer()
    
    let starVideo = SKSpriteNode(imageNamed: "starVideo")
    let records = SKSpriteNode(imageNamed: "records")
    var scoreLabel = AnimatedScoreLabel(text: "", score: 0, size: 25, color: k.flatColors.red)
    var numbersTap = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    var tapOnLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let numberLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let circularTimer = ProgressNode()
    let share = SKSpriteNode(imageNamed: NSLocalizedString("share", comment: "share-button"))
    let removeAds = SKSpriteNode(imageNamed: NSLocalizedString("removeAds", comment: "remove-ads"))
    let gameCenter =  SKSpriteNode(imageNamed: NSLocalizedString("gameCenter", comment: "game-center"))
    let recentScore = SKSpriteNode(imageNamed: NSLocalizedString("score", comment: "score"))
    let beginGame = SKSpriteNode(imageNamed: NSLocalizedString("beginGame", comment: "begin-game"))
    let home = SKSpriteNode(imageNamed: "home")
    let sound = SKSpriteNode(imageNamed: "sound")
    let info = SKSpriteNode(imageNamed: "info")
    let timeToMemorizeCounter = AnimatedScoreLabel(text: "", score: 0, size: 38, color: UIColor(rgba: "#e74c3c"))
    let timeToMemorizeText = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    
    var memorizeTimer = NSTimer()

    var number : Int = 0
    var numbersTapped = 0
    
    var hasGameEnded = false
    var hasRun = 0
    
    let numberBox1 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox2 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox3 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox4 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox5 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox6 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox7 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox8 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox9 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox10 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox11 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox12 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox13 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox14 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox15 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox16 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox17 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox18 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox19 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox20 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox21 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox22 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox23 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    let numberBox24 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
    
    var boxArray = [NumberBox]()
    
    var shareTitle = ""
    var shareMessage = ""
    var shareImage = UIImage()
    var shareURL = NSURL()

     override init(size: CGSize) {
        super.init(size: size)
        
        //currentMode = mode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
    }
    
    func start(mode: kGameMode, cam: SKCameraNode?)  {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.productPurchased), name: IAPHelperProductPurchasedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(productCancelled), name: "cancelled", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.rewardUser(_:)), name: "videoRewarded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.setPaused), name: "pauseGame", object: nil)
        
        products = []
        Products.store.requestProductsWithCompletionHandler { (success, products) in
            if success {
                self.products = products
            }
        }
        
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("hasRemovedAds") as? Bool {
            FTLogging().FTLog("all ads are gone")
            
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("hideBanner", object: nil)
        }
        
        size = CGSizeMake(640, 960)
        backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        scaleMode = .AspectFill
        
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        background.size = self.size
        background.zPosition = -10
        //addChild(background)
        
        if mode != .kMemory || mode != .kBuildUp || mode == .kFollow {
            addNumbers()
            
            setup(mode, cam: cam)
            
            for box in boxArray {
                box.scale()
            }
        }
    }
    
    func addNumbers() {
        scoreLabel.text = ""
        
        numberBox1.position = CGPoint(x:170, y:700)
        numberBox1.indexs = array[0]
        self.addChild(numberBox1)
        
        numberBox2.indexs = array[1]
        numberBox2.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y)
        self.addChild(numberBox2)
        
        numberBox3.indexs = array[2]
        numberBox3.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y)
        self.addChild(numberBox3)
        
        numberBox4.indexs = array[3]
        numberBox4.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y)
        self.addChild(numberBox4)
        
        numberBox5.indexs = array[4]
        numberBox5.position = CGPoint(x:numberBox1.position.x, y:numberBox1.position.y - 100)
        self.addChild(numberBox5)
        
        numberBox6.indexs = array[5]
        numberBox6.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y - 100)
        self.addChild(numberBox6)
        
        numberBox7.indexs = array[6]
        numberBox7.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y - 100)
        self.addChild(numberBox7)
        
        numberBox8.indexs = array[7]
        numberBox8.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y - 100)
        self.addChild(numberBox8)
        
        numberBox9.indexs = array[8]
        numberBox9.position = CGPoint(x:numberBox1.position.x, y:numberBox1.position.y - 200)
        self.addChild(numberBox9)
        
        numberBox10.indexs = array[9]
        numberBox10.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y - 200)
        self.addChild(numberBox10)
        
        numberBox11.indexs = array[10]
        numberBox11.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y - 200)
        self.addChild(numberBox11)
        
        numberBox12.indexs = array[11]
        numberBox12.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y - 200)
        self.addChild(numberBox12)
        
        numberBox13.indexs = array[12]
        numberBox13.position = CGPoint(x:numberBox1.position.x, y:numberBox1.position.y - 300)
        self.addChild(numberBox13)
        
        numberBox14.indexs = array[13]
        numberBox14.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y - 300)
        self.addChild(numberBox14)
        
        numberBox15.indexs = array[14]
        numberBox15.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y - 300)
        self.addChild(numberBox15)
        
        numberBox16.indexs = array[15]
        numberBox16.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y - 300)
        self.addChild(numberBox16)
        
        numberBox17.indexs = array[16]
        numberBox17.position = CGPoint(x:numberBox1.position.x, y:numberBox1.position.y - 400)
        self.addChild(numberBox17)
        
        numberBox18.indexs = array[17]
        numberBox18.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y - 400)
        self.addChild(numberBox18)
        
        numberBox19.indexs = array[18]
        numberBox19.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y - 400)
        self.addChild(numberBox19)
        
        numberBox20.indexs = array[19]
        numberBox20.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y - 400)
        self.addChild(numberBox20)
        
        numberBox21.indexs = array[20]
        numberBox21.position = CGPoint(x:numberBox1.position.x, y:numberBox1.position.y - 500)
        self.addChild(numberBox21)
        
        numberBox22.indexs = array[21]
        numberBox22.position = CGPoint(x:numberBox1.position.x + 100, y:numberBox1.position.y - 500)
        self.addChild(numberBox22)
        
        numberBox23.indexs = array[22]
        numberBox23.position = CGPoint(x:numberBox2.position.x + 100, y:numberBox1.position.y - 500)
        self.addChild(numberBox23)
        
        numberBox24.indexs = array[23]
        numberBox24.position = CGPoint(x:numberBox3.position.x + 100, y:numberBox1.position.y - 500)
        self.addChild(numberBox24)
        
        self.tapOnLabel.runAction(SKAction.moveToY(90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        self.numberLabel.runAction(SKAction.moveToY(90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0), completion: {
        })
        
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("hasRemovedAds") as? Bool {
            NSNotificationCenter.defaultCenter().postNotificationName("hideAds", object: nil)
        }
        
        boxArray.append(numberBox1)
        boxArray.append(numberBox2)
        boxArray.append(numberBox3)
        boxArray.append(numberBox4)
        boxArray.append(numberBox5)
        boxArray.append(numberBox6)
        boxArray.append(numberBox7)
        boxArray.append(numberBox8)
        boxArray.append(numberBox9)
        boxArray.append(numberBox10)
        boxArray.append(numberBox11)
        boxArray.append(numberBox12)
        boxArray.append(numberBox13)
        boxArray.append(numberBox14)
        boxArray.append(numberBox15)
        boxArray.append(numberBox16)
        boxArray.append(numberBox17)
        boxArray.append(numberBox18)
        boxArray.append(numberBox19)
        boxArray.append(numberBox20)
        boxArray.append(numberBox21)
        boxArray.append(numberBox22)
        boxArray.append(numberBox23)
        boxArray.append(numberBox24)
        
    }
    
    func startCountDown() {
        countdown.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        countdown.zPosition = 10
        addChild(countdown)
        
        countdownTimer = NSTimer.every(1, { 
            self.countdownCheck()
        })
        
        let dbackground = SKSpriteNode(imageNamed: "background")
        dbackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        dbackground.size = self.size
        dbackground.alpha = 0.8
        dbackground.name = "bg"
        dbackground.zPosition = 9
        addChild(dbackground)
        
        countdownArray.append(countdown)
        countdownArray.append(dbackground)
        
    }
    
    func countdownCheck() {
        countdown.counterUpdate()
    }
    
    func updateScore(score: Int) {
        let oldAmount = NSUserDefaults.standardUserDefaults().integerForKey(kNumbersKey)
        let newAmountToAdd = Int(oldAmount + score)
        let newAmount = Int(newAmountToAdd)
        
        NSUserDefaults.standardUserDefaults().setInteger(newAmount, forKey: kNumbersKey)
        print("old \(oldAmount) vs new \(newAmount) also before removing score \(newAmountToAdd) vs saved \(NSUserDefaults.standardUserDefaults().integerForKey(kNumbersKey))" )
    }
    
    func counterComplete(aNotification: NSNotification) {
    }
    
    func setup(mode: kGameMode, cam: SKCameraNode?) {
        
        let timerSpace = SKTexture(imageNamed: "timerSpace")
        circularTimer.position = CGPointMake(470, 850)
        circularTimer.radius = timerSpace.size().width / 2
        circularTimer.width = 8.0
        circularTimer.zPosition = 2
        circularTimer.color = UIColor(rgba: "#e74c3c")
        circularTimer.backgroundColor = UIColor(rgba: "#434343")
        
        scoreLabel.position = CGPointMake(circularTimer.position.x - 320, circularTimer.position.y)
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.fontColor = UIColor(rgba: "#e74c3c")
        
        numbersTap.text = "NUMBERS TAPPED"
        numbersTap.position = CGPointMake(scoreLabel.position.x + 15, scoreLabel.position.y)
        numbersTap.horizontalAlignmentMode = .Left
        numbersTap.fontColor = UIColor.whiteColor()
        numbersTap.fontSize = 25
        numbersTap.zPosition = scoreLabel.zPosition
        
        starVideo.position = CGPointMake(scoreLabel.position.x + 10, scoreLabel.position.y - 32)
        starVideo.name = "starVideo"
        starVideo.zPosition = 2
        
        records.position = CGPointMake(starVideo.position.x + 65, starVideo.position.y)
        records.name = "records"
        records.zPosition = 2
        
        if mode == .kFollow && cam != nil{
            cam!.addChild(circularTimer)
            cam!.addChild(scoreLabel)
            cam!.addChild(numbersTap)
            cam!.addChild(starVideo)
            cam!.addChild(records)

        } else {
            addChild(circularTimer)
            addChild(scoreLabel)
            addChild(numbersTap)
            addChild(starVideo)
            addChild(records)

        }
        
        if mode != .kMemory {
            self.tapOnLabel.fontColor = UIColor.whiteColor()
            self.tapOnLabel.fontSize = 30
            self.tapOnLabel.text = "TAP NUMBER:"
            self.tapOnLabel.horizontalAlignmentMode = .Center
            self.tapOnLabel.verticalAlignmentMode = .Center
            self.tapOnLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 25, -90)
            
            if mode == .kFollow && cam != nil{
                cam!.addChild(tapOnLabel)
            } else {
                addChild(tapOnLabel)
            }
            
            self.number = self.randomNumber()
            
            self.numberLabel.fontColor = UIColor(rgba: "#e74c3c")
            self.numberLabel.fontSize = 38
            self.numberLabel.text = String(self.number)
            self.numberLabel.horizontalAlignmentMode = .Center
            self.numberLabel.verticalAlignmentMode = .Center
            self.numberLabel.position = CGPointMake(self.tapOnLabel.position.x + 130, -90)
            if mode == .kFollow && cam != nil{
                cam!.addChild(numberLabel)
            } else {
                addChild(numberLabel)
            }
            
            self.tapOnLabel.runAction(SKAction.moveToY(90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            self.numberLabel.runAction(SKAction.moveToY(90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            
        } else {
            timeToMemorizeText.fontColor = UIColor.whiteColor()
            timeToMemorizeText.fontSize = 30
            timeToMemorizeText.text = "TIME TO MEMORIZE:"
            timeToMemorizeText.horizontalAlignmentMode = .Center
            timeToMemorizeText.verticalAlignmentMode = .Center
            timeToMemorizeText.position = CGPointMake(CGRectGetMidX(self.frame) - 45, -90)
            addChild(timeToMemorizeText)
            
            timeToMemorizeCounter.fontColor = UIColor(rgba: "#e74c3c")
            timeToMemorizeCounter.fontSize = 38
            timeToMemorizeCounter.horizontalAlignmentMode = .Center
            timeToMemorizeCounter.verticalAlignmentMode = .Center
            timeToMemorizeCounter.position = CGPointMake(timeToMemorizeText.position.x + 180, -90)
            addChild(timeToMemorizeCounter)
            
            timeToMemorizeText.runAction(SKAction.moveToY(90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            timeToMemorizeCounter.runAction(SKAction.moveToY(75, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))

            memorizeTimer = NSTimer.every(1, {
                if self.counter < 0 {
                    self.counter -= 1
                    self.timeToMemorizeCounter.score = Int32(self.counter)
                };
                
                if self.counter == 0 {
                    self.memorizeTimer.invalidate()
                    self.finishedMemorizeCounter()
                }
            })
        }
        
        
    }
    
    func setShareDetails(message: String, image: UIImage, url: NSURL) {
        shareMessage = message
        shareImage = image
        shareURL = url
    }
    
    func finishedMemorizeCounter() {
    }

    func randomWord() {
        
        let getRandom = randomSequenceGenerator(1, max: 99)
        for _ in 1...99 {
            array.append(getRandom());
            
        }
        
    }
    
    func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
        var numbers: [Int] = []
        return {
            if numbers.count == 0 {
                numbers = Array(min ... max)
            }
            
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.removeAtIndex(index)
        }
    }
    
    func randomNumber() -> Int {
        
        if array.count > 0 {
            
            var randNum = 0
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(array.count)))
            
            // your random number
            randNum = array[arrayKey]
            
            // make sure the number isnt repeated
            array.removeAtIndex(arrayKey)
            
            return randNum;
            
        } else {
            resetScene()
            
            
            var randNum = 0
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(array.count)))
            
            // your random number
            randNum = array[arrayKey]
            
            // make sure the number isnt repeated
            array.removeAtIndex(arrayKey)
            
            return randNum;
            
        }
        
    }
    
    func setScore(score: Int) {
        numbersTapped = score
    }
    
    func getScore() -> Int {
        return numbersTapped
    }
    
    func prepareForGameOver() {
        //Override with custom code to prepair for Game Over the scene before the game over screen appears
    }
    
    func gameOver() {
        prepareForGameOver()
        
        let darkBG = SKSpriteNode(imageNamed: "background")
        darkBG.size = size
        darkBG.name = "darkBG"
        darkBG.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        darkBG.zPosition = 100
        darkBG.alpha = 0.8
        if self.children.contains(darkBG) != true {
            addChild(darkBG)
        }
        
        hasGameEnded = true
        
        NSUserDefaults.standardUserDefaults().highScore = numbersTapped
        
        recentScore.setScale(1.12)
        recentScore.name = "recentScore"
        recentScore.position = CGPointMake(CGRectGetMidX(self.frame) - 100, CGRectGetMidY(self.frame))
        recentScore.zPosition = 101
        recentScore.setScale(0)
        
        let recentScoreText = SKLabelNode(fontNamed: "Montserrat-SemiBold")
        recentScoreText.text = String(numbersTapped)
        recentScoreText.fontColor = UIColor.whiteColor()
        recentScoreText.fontSize = 42
        recentScoreText.zPosition = recentScore.zPosition + 1
        recentScoreText.horizontalAlignmentMode = .Center
        recentScoreText.verticalAlignmentMode = .Center
        recentScoreText.position.y = recentScore.size.height/2 - 28
        
        if recentScore.children.contains(recentScoreText) {} else { recentScore.addChild(recentScoreText) }
        
        if self.children.contains(recentScore) {} else { addChild(recentScore)
            recentScore.runAction(SKAction.scaleTo(1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        }
        
        gameCenter.name = "gameCenter"
        gameCenter.position = CGPointMake(recentScore.position.x + 180, recentScore.position.y)
        gameCenter.zPosition = 101
        if self.children.contains(gameCenter) {} else { addChild(gameCenter) }
        
        removeAds.name = "removeAds"
        removeAds.position = CGPointMake(gameCenter.position.x - 50, gameCenter.position.y + 140)
        removeAds.zPosition = 101
        removeAds.setScale(0.2)
        if self.children.contains(removeAds) {} else { addChild(removeAds) }
        
        removeAds.runAction(SKAction.scaleTo(1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        share.name = "share"
        share.position = CGPointMake(removeAds.position.x  - 20, removeAds.position.y - 270)
        share.zPosition = 101
        share.setScale(0.4)
        if self.children.contains(share) {} else { addChild(share) }
        
        share.runAction(SKAction.scaleTo(1, duration: 0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        beginGame.name = "beginGame"
        beginGame.position = CGPointMake(CGRectGetMidX(self.frame), -90)
        beginGame.zPosition = 101
        if self.children.contains(beginGame) {} else { addChild(beginGame) }
        
        beginGame.runAction(SKAction.moveToY(90, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        var arr = [SKSpriteNode]()
        
        home.name = "home"
        home.position = CGPoint(x: CGRectGetMidX(self.frame) + 145, y: 150)
        home.zPosition = 101
        home.alpha = 1
        home.setScale(0)
        if self.children.contains(home) {} else { addChild(home) }
        
        
        info.name = "home"
        info.position = CGPoint(x: home.position.x - 50, y: home.position.y)
        info.zPosition = 101
        info.alpha = 1
        info.setScale(0)
        if self.children.contains(info) {} else { addChild(info) }
        
        
        sound.name = "home"
        sound.position = CGPoint(x: info.position.x - 50, y: home.position.y)
        sound.zPosition = 101
        sound.alpha = 1
        sound.setScale(0)
        if self.children.contains(sound) {} else { addChild(sound) }
        
        
        arr.append(home)
        arr.append(info)
        arr.append(sound)
        
        for item in arr {
            if UIDevice.currentDevice().type == .iPadMini1 {
                item.runAction(SKAction.scaleTo(0.4, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            } else {
                item.runAction(SKAction.scaleTo(1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            }
        }
        
        let gameOverText = SKLabelNode(fontNamed: "Montserrat-SemiBold")
        gameOverText.color = UIColor.whiteColor()
        gameOverText.horizontalAlignmentMode = .Center
        gameOverText.zPosition = 101
        gameOverText.text = "game over"
        gameOverText.name = "gameOver"
        gameOverText.fontSize = 55
        gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), removeAds.position.y + 1000)
        if self.childNodeWithName("gameOver") != nil {
            addChild(gameOverText)
        }
        
        gameOverText.runAction(SKAction.moveToY(removeAds.position.y + 140, duration: 1))
        
        hasRun = 1
        
        Armchair.userDidSignificantEvent(true)
    }
    
    func clearGameOver() {
        removeAds.runAction(SKAction.moveToY(-1000, duration: 2.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        recentScore.runAction(SKAction.moveToY(-1000, duration: 2.1, delay: 1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        beginGame.runAction(SKAction.moveToY(-1000, duration: 2.2, delay: 2, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        share.runAction(SKAction.moveToY(-1000, duration: 2.4, delay: 1.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        gameCenter.runAction(SKAction.moveToY(-1000, duration: 2, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)) {
            
            self.childNodeWithName("darkBG")?.removeFromParent()
            self.childNodeWithName("gameOver")?.removeFromParent()
            self.childNodeWithName("gameOver")?.removeAllActions()
            self.childNodeWithName("gameOver")?.removeAllChildren()
            
            self.recentScore.removeFromParent()
            self.recentScore.removeAllActions()
            self.recentScore.removeAllChildren()
            
            self.gameCenter.removeFromParent()
            self.gameCenter.removeAllChildren()
            self.gameCenter.removeAllActions()
            
            self.removeAds.removeFromParent()
            self.removeAds.removeAllChildren()
            self.removeAds.removeAllActions()
            
            self.share.removeFromParent()
            self.share.removeAllChildren()
            self.share.removeAllActions()
            
            self.beginGame.removeFromParent()
            self.beginGame.removeAllChildren()
            self.beginGame.removeAllActions()
            
            self.home.removeAllActions()
            self.home.removeFromParent()
            self.home.removeAllChildren()
            
            self.info.removeFromParent()
            self.info.removeAllChildren()
            self.sound.removeFromParent()
            self.sound.removeAllActions()
            
            self.hasGameEnded = false
            
            self.resetScene()
            
        }

    }

    func resetScene() {
        
        array.removeAll()
        randomWord()
        number = randomNumber()
        numberLabel.text = "\(number)"
        
    }
    
    @objc private func productCancelled() {
        MBProgressHUD.hideAllHUDsForView(self.view!, animated: true)
    }
    
    func handleTouchedPoint(location: CGPoint) {
        if hasGameEnded {
            if gameCenter.containsPoint(location) {
                FTLogging().FTLog("game center")
                
                gameCenter.runAction(k.Sounds.blopAction1)
                
                //let vC = self.view!.window?.rootViewController
                //GameKitHelper.sharedGameKitHelper.showGameCenter(vC!, viewState: .Default)
            }
            
            if home.containsPoint(location) {
                FTLogging().FTLog("home")
                let homeScene = HomeScene()
                self.view?.presentScene(homeScene, transition: SKTransition.fadeWithColor(UIColor(rgba: "#434343"), duration: 2))
                
            };
            
            if sound.containsPoint(location) {
                FTLogging().FTLog("sound")
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
                
                
            };
            
            if info.containsPoint(location) {
                let vc = self.view?.window?.rootViewController
                let alert = UIAlertController(title: "How To Play", message: "Simply tap the tile with the number that's displayed at the bottom of the screen while avoid to run out of time! \r\nHow fast can you tap? \r\n\r\nHow long can you last? \r\n\r\nMade by Jesse Onolememen 2016 \r\nIcons Provided by FreePik/FlatIcon", preferredStyle: .Alert) // 1
                let firstAction = UIAlertAction(title: "Yeah I got it!", style: .Default) { (alert: UIAlertAction!) -> Void in
                    let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
                    loadingNotification.mode = .Indeterminate
                    loadingNotification.labelText = "Loading"
                    loadingNotification.userInteractionEnabled = false
                    
                    NSLog("You pressed button one")
                    
                } // 2
                let restorePurchases = UIAlertAction(title: "Restore Purchases", style: .Default, handler: { (UIAlertAction) in
                    //self.restoreTapped()
                })
                
                alert.addAction(firstAction) // 4
                alert.addAction(restorePurchases)
                vc!.presentViewController(alert, animated: true, completion:nil) // 6
            }
            
            if share.containsPoint(location) {
                FTLogging().FTLog("share")
                
                share.runAction(k.Sounds.blopAction1)
                
                if let _ = NSURL(string: "") {
                    let objectsToShare = [shareMessage, shareURL, shareImage]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    //New Excluded Activities Code
                    activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList]
                    
                    let vC = self.view?.window?.rootViewController
                    vC!.presentViewController(activityVC, animated: true, completion: nil)
                    
                }
            }
            if removeAds.containsPoint(location) {
                FTLogging().FTLog("remove ads")
                let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view!, animated: true)
                loadingNotification.mode = .Indeterminate
                loadingNotification.labelText = "Loading"
                loadingNotification.userInteractionEnabled = false
                
                removeAds.runAction(k.Sounds.blopAction1)
                //purchaseProduct(0)
            }
            
            if beginGame.containsPoint(location) {
                FTLogging().FTLog("begin game")
                beginGame.runAction(k.Sounds.blopAction1)
                clearGameOver()
            }
            
        }
        
        if home.containsPoint(location) {
            FTLogging().FTLog("home")
            let homeScene = HomeScene()
            self.view?.presentScene(homeScene, transition: SKTransition.fadeWithColor(UIColor(rgba: "#434343"), duration: 2))
        };

    }
}