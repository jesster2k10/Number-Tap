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
import Appirater

enum kGameMode {
    case kMultiplayer
    case kMemory
    case kBuildUp
    case kFollow
    case kShuffle
}

class BaseScene : InitScene {
    let background = SKSpriteNode(imageNamed: "background")
    var array = [Int]()
    var products = [SKProduct]()
    var continueArray = [SKNode]()
    var topArray = [SKNode]()
    var timerArray = [Timer]()
    var countdownArray = [SKNode]()
    
    var currentMode: gameMode!
    
    var counter = 10
    
    let countdown = CountdownNode(texture: nil, color: UIColor.clear, size: CGSize(width: 0, height: 0))
    var countdownTimer = Timer()
    
    let starVideo = SKSpriteNode(imageNamed: "starVideo")
    let records = SKSpriteNode(imageNamed: "records")
    var scoreLabel = AnimatedScoreLabel(text: "", score: 0, size: 25, color: k.flatColors.red)
    var numbersTap = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    var tapOnLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let numberLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    var mostTappedLabel = SKLabelNode(fontNamed: k.Montserrat.Light)
    var mostLabel = AnimatedScoreLabel(text: "Score", score: 0, size: 20, color: k.flatColors.red)
    var mostCound = 0
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
    
    var memorizeTimer = Timer()

    var number : Int = 0
    var numbersTapped = 0
    
    var hasGameEnded = false
    var hasRun = 0
    
    var opponentTappedTextLabel = SKLabelNode(fontNamed: k.Montserrat.Light)
    var opponentTappedLabel = AnimatedScoreLabel(text: "Score", score: 0, size: 20, color: k.flatColors.red)!
    var mostCount = 0
    
    let numberBox1 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox2 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox3 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox4 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox5 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox6 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox7 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox8 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox9 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox10 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox11 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox12 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox13 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox14 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox15 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox16 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox17 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox18 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox19 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox20 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox21 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox22 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox23 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    let numberBox24 = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
    
    var boxArray = [NumberBox]()
    
    var shareTitle = ""
    var shareMessage = ""
    var shareImage = UIImage()
    var shareURL = URL(fileURLWithPath: "")

     override init(size: CGSize) {
        super.init(size: size)
        
        //currentMode = mode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    func start(_ mode: kGameMode, cam: SKCameraNode?)  {
        setUpListners()

        UserDefaults.standard.set(false, forKey: "nk")

        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.productPurchased), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(productCancelled), name: NSNotification.Name(rawValue: "cancelled"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.rewardUser(_:)), name: NSNotification.Name(rawValue: "videoRewarded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.setPaused), name: NSNotification.Name(rawValue: "pauseGame"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGameMode), name: NSNotification.Name(rawValue: kPlayGameModeNotification), object: nil)
        
        
        
        products = []
        Products.store.requestProducts{success, products in
            if success {
                self.products = products!
            }
        }
        
        if let _ = UserDefaults.standard.object(forKey: "hasRemovedAds") as? Bool {
            FTLogging().FTLog("all ads are gone")
            
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "hideBanner"), object: nil)
        }
        
        size = CGSize(width: 640, height: 960)
        backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        scaleMode = .aspectFill
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = self.size
        background.zPosition = -10
        //addChild(background)
        
        if mode != .kMemory || mode != .kBuildUp || mode == .kFollow || mode != .kMultiplayer {
            addNumbers()
            
            setup(mode, cam: cam)
            
            for box in boxArray {
                box.scale()
            }
        }
        
        GameModeHelper.sharedHelper.pausePointsCheck()

    }
    
    func addNumbers() {
        scoreLabel?.text = ""
        
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
        
        self.tapOnLabel.run(SKAction.moveTo(y: 90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        self.numberLabel.run(SKAction.moveTo(y: 90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0), completion: {
        })
        
        if let _ = UserDefaults.standard.object(forKey: "hasRemovedAds") as? Bool {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "hideAds"), object: nil)
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
        countdown.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        countdown.zPosition = 10
        addChild(countdown)
        
        countdownTimer = Timer.every(1, { 
            self.countdownCheck()
        })
        
        let dbackground = SKSpriteNode(imageNamed: "background")
        dbackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
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
    
    func updateScore(_ score: Int) {
        let oldAmount = UserDefaults.standard.integer(forKey: kNumbersKey)
        let newAmountToAdd = Int(oldAmount + score)
        let newAmount = Int(newAmountToAdd)
        
        UserDefaults.standard.set(newAmount, forKey: kNumbersKey)
        print("old \(oldAmount) vs new \(newAmount) also before removing score \(newAmountToAdd) vs saved \(UserDefaults.standard.integer(forKey: kNumbersKey))" )
    }
    
    func counterComplete(_ aNotification: Notification) {
    }
    
    func setup(_ mode: kGameMode, cam: SKCameraNode?) {
        
        let timerSpace = SKTexture(imageNamed: "timerSpace")
        circularTimer.position = CGPoint(x: 470, y: 850)
        circularTimer.radius = timerSpace.size().width / 2
        circularTimer.width = 8.0
        circularTimer.zPosition = 2
        circularTimer.color = UIColor(rgba: "#e74c3c")
        circularTimer.backgroundColor = UIColor(rgba: "#434343")
        
        scoreLabel?.position = CGPoint(x: circularTimer.position.x - 320, y: circularTimer.position.y)
        scoreLabel?.horizontalAlignmentMode = .left
        scoreLabel?.fontColor = UIColor(rgba: "#e74c3c")
        
        if mode == .kMultiplayer {
            opponentTappedLabel.position = CGPoint(x: (scoreLabel?.position.x)!, y: (scoreLabel?.position.y)! - 30)
            opponentTappedLabel.horizontalAlignmentMode = .left
            opponentTappedLabel.fontColor = k.flatColors.red
            opponentTappedLabel.score = 0
            opponentTappedLabel.text = ""
            addChild(opponentTappedLabel)
            
            opponentTappedTextLabel.position = CGPoint(x: opponentTappedLabel.position.x + 20, y: opponentTappedLabel.position.y)
            opponentTappedTextLabel.fontSize = opponentTappedLabel.fontSize
            opponentTappedTextLabel.fontColor = UIColor.white
            opponentTappedTextLabel.horizontalAlignmentMode = .left
            opponentTappedTextLabel.zPosition = opponentTappedLabel.zPosition
            opponentTappedTextLabel.text = "Oppenent Tapped"
            addChild(opponentTappedTextLabel)
        } else {
            starVideo.position = CGPoint(x: (scoreLabel?.position.x)! + 10, y: (scoreLabel?.position.y)! - 32)
            numbersTap.text = "NUMBERS TAPPED"
            numbersTap.position = CGPoint(x: (scoreLabel?.position.x)! + 15, y: (scoreLabel?.position.y)!)
            numbersTap.horizontalAlignmentMode = .left
            numbersTap.fontColor = UIColor.white
            numbersTap.fontSize = 25
            numbersTap.zPosition = (scoreLabel?.zPosition)!
            
            mostLabel?.position = CGPoint(x: (scoreLabel?.position.x)!, y: (scoreLabel?.position.y)! - 30)
            mostLabel?.horizontalAlignmentMode = .left
            mostLabel?.fontColor = k.flatColors.red
            mostLabel?.score = Int32(UserDefaults.standard.highScore)
            mostLabel?.text = ""
            
            mostTappedLabel.position = CGPoint(x: mostLabel!.position.x + 20, y: mostLabel!.position.y)
            mostTappedLabel.fontSize = mostLabel!.fontSize
            mostTappedLabel.fontColor = UIColor.white
            mostTappedLabel.horizontalAlignmentMode = .left
            mostTappedLabel.zPosition = mostLabel!.zPosition
            mostTappedLabel.text = "MOST TAPPED"
            
        }
        
        if mode == .kFollow && cam != nil{
            cam!.addChild(circularTimer)
            cam!.addChild(scoreLabel!)
            cam!.addChild(numbersTap)
            cam!.addChild(starVideo)
            cam!.addChild(records)

        } else {
            addChild(circularTimer)
            addChild(scoreLabel!)
            addChild(numbersTap)
            addChild(mostLabel!)
            addChild(mostTappedLabel)
        }
        
        if mode != .kMemory {
            self.tapOnLabel.fontColor = UIColor.white
            self.tapOnLabel.fontSize = 30
            self.tapOnLabel.text = "TAP NUMBER:"
            self.tapOnLabel.horizontalAlignmentMode = .center
            self.tapOnLabel.verticalAlignmentMode = .center
            self.tapOnLabel.position = CGPoint(x: self.frame.midX - 25, y: -90)
            
            if mode == .kFollow && cam != nil{
                cam!.addChild(tapOnLabel)
            } else {
                addChild(tapOnLabel)
            }
            
            self.number = self.randomNumber()
            
            self.numberLabel.fontColor = UIColor(rgba: "#e74c3c")
            self.numberLabel.fontSize = 38
            self.numberLabel.text = String(self.number)
            self.numberLabel.horizontalAlignmentMode = .center
            self.numberLabel.verticalAlignmentMode = .center
            self.numberLabel.position = CGPoint(x: self.tapOnLabel.position.x + 130, y: -90)
            if mode == .kFollow && cam != nil{
                cam!.addChild(numberLabel)
            } else {
                addChild(numberLabel)
            }
            
            self.tapOnLabel.run(SKAction.moveTo(y: 90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            self.numberLabel.run(SKAction.moveTo(y: 90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            
        } else {
            timeToMemorizeText.fontColor = UIColor.white
            timeToMemorizeText.fontSize = 30
            timeToMemorizeText.text = "TIME TO MEMORIZE:"
            timeToMemorizeText.horizontalAlignmentMode = .center
            timeToMemorizeText.verticalAlignmentMode = .center
            timeToMemorizeText.position = CGPoint(x: self.frame.midX - 45, y: -90)
            addChild(timeToMemorizeText)
            
            timeToMemorizeCounter?.fontColor = UIColor(rgba: "#e74c3c")
            timeToMemorizeCounter?.fontSize = 38
            timeToMemorizeCounter?.horizontalAlignmentMode = .center
            timeToMemorizeCounter?.verticalAlignmentMode = .center
            timeToMemorizeCounter?.position = CGPoint(x: timeToMemorizeText.position.x + 180, y: -90)
            addChild(timeToMemorizeCounter!)
            
            timeToMemorizeText.run(SKAction.moveTo(y: 90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            timeToMemorizeCounter?.run(SKAction.moveTo(y: 75, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))

            memorizeTimer = Timer.every(1, {
                if self.counter < 0 {
                    self.counter -= 1
                    self.timeToMemorizeCounter?.score = Int32(self.counter)
                };
                
                if self.counter == 0 {
                    self.memorizeTimer.invalidate()
                    self.finishedMemorizeCounter()
                }
            })
        }
        
        
    }
    
    func setShareDetails(_ message: String, image: UIImage, url: URL) {
        shareMessage = message
        shareImage = image
        shareURL = url
    }
    
    func finishedMemorizeCounter() {
    }

    func randomWord() {
        
        let getRandom = randomSequenceGenerator(1, max: 99)
        for _ in 1...24 {
            array.append(getRandom());
            
        }
        
    }
    
    func randomSequenceGenerator(_ min: Int, max: Int) -> () -> Int {
        var numbers: [Int] = []
        return {
            if numbers.count == 0 {
                numbers = Array(min ... max)
            }
            
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.remove(at: index)
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
            array.remove(at: arrayKey)
            
            return randNum;
            
        } else {
            resetScene()
            toSceneReset()
            
            var randNum = 0
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(array.count)))
            
            // your random number
            randNum = array[arrayKey]
            
            // make sure the number isnt repeated
            array.remove(at: arrayKey)
            
            return randNum;
            
        }
        
    }
    
    func toSceneReset() {
        
    }
    
    func setScore(_ score: Int) {
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
        
        GameModeHelper.sharedHelper.resetPointsCheck()

        let darkBG = SKSpriteNode(imageNamed: "background")
        darkBG.size = size
        darkBG.name = "darkBG"
        darkBG.position = CGPoint(x: frame.midX, y: frame.midY)
        darkBG.zPosition = 100
        darkBG.alpha = 0.8
        if self.children.contains(darkBG) != true {
            addChild(darkBG)
        }
        
        hasGameEnded = true
        
        UserDefaults.standard.highScore = numbersTapped
        
        recentScore.setScale(1.12)
        recentScore.name = "recentScore"
        recentScore.position = CGPoint(x: self.frame.midX - 100, y: self.frame.midY)
        recentScore.zPosition = 101
        recentScore.setScale(0)
        
        let recentScoreText = SKLabelNode(fontNamed: "Montserrat-SemiBold")
        recentScoreText.text = String(numbersTapped)
        recentScoreText.fontColor = UIColor.white
        recentScoreText.fontSize = 42
        recentScoreText.zPosition = recentScore.zPosition + 1
        recentScoreText.horizontalAlignmentMode = .center
        recentScoreText.verticalAlignmentMode = .center
        recentScoreText.position.y = recentScore.size.height/2 - 28
        
        if recentScore.children.contains(recentScoreText) {} else { recentScore.addChild(recentScoreText) }
        
        if self.children.contains(recentScore) {} else { addChild(recentScore)
            recentScore.run(SKAction.scale(to: 1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        }
        
        gameCenter.name = "gameCenter"
        gameCenter.position = CGPoint(x: recentScore.position.x + 180, y: recentScore.position.y)
        gameCenter.zPosition = 101
        if self.children.contains(gameCenter) {} else { addChild(gameCenter) }
        
        removeAds.name = "removeAds"
        removeAds.position = CGPoint(x: gameCenter.position.x - 50, y: gameCenter.position.y + 140)
        removeAds.zPosition = 101
        removeAds.setScale(0.2)
        if self.children.contains(removeAds) {} else { addChild(removeAds) }
        
        removeAds.run(SKAction.scale(to: 1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        share.name = "share"
        share.position = CGPoint(x: removeAds.position.x  - 20, y: removeAds.position.y - 270)
        share.zPosition = 101
        share.setScale(0.4)
        if self.children.contains(share) {} else { addChild(share) }
        
        share.run(SKAction.scale(to: 1, duration: 0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        beginGame.name = "beginGame"
        beginGame.position = CGPoint(x: self.frame.midX, y: -90)
        beginGame.zPosition = 101
        if self.children.contains(beginGame) {} else { addChild(beginGame) }
        
        beginGame.run(SKAction.moveTo(y: 90, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        var arr = [SKSpriteNode]()
        
        home.name = "home"
        home.position = CGPoint(x: self.frame.midX + 145, y: 150)
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
            if !UIScreen.main.isRetina() {
                item.run(SKAction.scale(to: 0.4, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            } else {
                item.run(SKAction.scale(to: 1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
            }
        }
        
        let gameOverText = SKLabelNode(fontNamed: "Montserrat-SemiBold")
        gameOverText.color = UIColor.white
        gameOverText.horizontalAlignmentMode = .center
        gameOverText.zPosition = 101
        gameOverText.text = "game over"
        gameOverText.name = "gameOver"
        gameOverText.fontSize = 55
        gameOverText.position = CGPoint(x: self.frame.midX, y: removeAds.position.y + 1000)
        if self.childNode(withName: "gameOver") != nil {
            addChild(gameOverText)
        }
        
        gameOverText.run(SKAction.moveTo(y: removeAds.position.y + 140, duration: 1))
        
        hasRun = 1
        
        Appirater.userDidSignificantEvent(true)
    }
    
    func clearGameOver() {
        removeAds.run(SKAction.moveTo(y: -1000, duration: 2.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        recentScore.run(SKAction.moveTo(y: -1000, duration: 2.1, delay: 1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        beginGame.run(SKAction.moveTo(y: -1000, duration: 2.2, delay: 2, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        share.run(SKAction.moveTo(y: -1000, duration: 2.4, delay: 1.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        gameCenter.run(SKAction.moveTo(y: -1000, duration: 2, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)) {
            
            self.childNode(withName: "darkBG")?.removeFromParent()
            self.childNode(withName: "gameOver")?.removeFromParent()
            self.childNode(withName: "gameOver")?.removeAllActions()
            self.childNode(withName: "gameOver")?.removeAllChildren()
            
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

    func resetScene() {
        
        array.removeAll()
        randomWord()
        number = randomNumber()
        numberLabel.text = "\(number)"
        
    }
    
    @objc fileprivate func productCancelled() {
        MBProgressHUD.hideAllHUDs(for: self.view!, animated: true)
    }
    
    func showShare(image: UIImage) {
        blur(animationDuration: 1)
        
        let frame = SKSpriteNode(imageNamed: "polaroid-frame")
        let shareButton = SKSpriteNode(imageNamed: "polaroid-share".localized)
        let texture = SKTexture(image: image)
        let frameImage = SKSpriteNode(texture: texture)
        
        frame.name = "frame"
        frame.position = CGPoint(x: self.view!.frame.midX, y: self.view!.frame.midY)
        frame.zPosition = self.zPosition + 2
        
        shareButton.name = "share-button"
        shareButton.position = CGPoint(x: 4, y: -123.058)
        shareButton.zPosition = frame.zPosition + 1
        frame.addChild(shareButton)
        
        frameImage.name = "frame-image"
        frameImage.position =  CGPoint(x: -0.994, y: 35.796)
        frameImage.zPosition = shareButton.zPosition
        frame.addChild(frameImage)
        addChild(frame)
    }
    
    func handleTouchedPoint(_ location: CGPoint) {
        if hasGameEnded {
            if gameCenter.contains(location) {
                FTLogging().FTLog("game center")
                
                gameCenter.run(k.Sounds.blopAction1)
                
                //let vC = self.view!.window?.rootViewController
                //GameKitHelper.sharedGameKitHelper.showGameCenter(vC!, viewState: .Default)
            }
            
            if home.contains(location) {
                FTLogging().FTLog("home")
                let homeScene = HomeScene()
                self.view?.presentScene(homeScene, transition: SKTransition.fade(with: UIColor(rgba: "#434343"), duration: 2))
                
            };
            
            if sound.contains(location) {
                FTLogging().FTLog("sound")
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
                
                
            };
            
            if info.contains(location) {
                let vc = self.view?.window?.rootViewController
                let alert = UIAlertController(title: "How To Play", message: "Simply tap the tile with the number that's displayed at the bottom of the screen while avoid to run out of time! \r\nHow fast can you tap? \r\n\r\nHow long can you last? \r\n\r\nMade by Jesse Onolememen 2016 \r\nIcons Provided by FreePik/FlatIcon", preferredStyle: .alert) // 1
                let firstAction = UIAlertAction(title: "Yeah I got it!", style: .default) { (alert: UIAlertAction!) -> Void in
                    let loadingNotification = MBProgressHUD.showAdded(to: self.view!, animated: true)
                    loadingNotification.mode = .indeterminate
                    loadingNotification.labelText = "Loading"
                    loadingNotification.isUserInteractionEnabled = false
                    
                    NSLog("You pressed button one")
                    
                } // 2
                let restorePurchases = UIAlertAction(title: "Restore Purchases", style: .default, handler: { (UIAlertAction) in
                    //self.restoreTapped()
                })
                
                alert.addAction(firstAction) // 4
                alert.addAction(restorePurchases)
                vc!.present(alert, animated: true, completion:nil) // 6
            }
            
            if share.contains(location) {
                FTLogging().FTLog("share")
                
                share.run(k.Sounds.blopAction1)
                
                let objectsToShare = [shareMessage, shareURL, shareImage] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                //New Excluded Activities Code
                activityVC.excludedActivityTypes = [UIActivityType.addToReadingList]
                
                let vC = self.view?.window?.rootViewController
                vC!.present(activityVC, animated: true, completion: nil)
                    
                
            }
            if removeAds.contains(location) {
                FTLogging().FTLog("remove ads")
                let loadingNotification = MBProgressHUD.showAdded(to: self.view!, animated: true)
                loadingNotification.mode = .indeterminate
                loadingNotification.labelText = "Loading"
                loadingNotification.isUserInteractionEnabled = false
                
                removeAds.run(k.Sounds.blopAction1)
                //purchaseProduct(0)
            }
            
            if beginGame.contains(location) {
                FTLogging().FTLog("begin game")
                beginGame.run(k.Sounds.blopAction1)
                clearGameOver()
            }
            
        }
        
        if home.contains(location) {
            FTLogging().FTLog("home")
            let homeScene = HomeScene()
            self.view?.presentScene(homeScene, transition: SKTransition.fade(with: UIColor(rgba: "#434343"), duration: 2))
        };

    }
}
