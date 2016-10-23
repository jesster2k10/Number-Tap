//
//  GameScene.swift
//  Number Tap
//
//  Created by jesse on 12/03/2016.
//  Copyright (c) 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit
import GameKit
import StoreKit
import ReplayKit
import MBProgressHUD
import Appirater

let kNumbersKey = "NumberKey"
let kImpossibleKey = "kImpossibleKey"
let kEasyKey = "kEasyKey"

class GameScene: InitScene, RPScreenRecorderDelegate {
    var loadingNotification = MBProgressHUD()
    var array = [Int]()
    var products = [SKProduct]()
    var continueArray = [SKNode]()
    var topArray = [SKNode]()
    
    var rater = false
    var recording = false
    
    var number = 0
    var score : Int = 0
    var numbersTapped : Int = 0
    var hasRun = 0
    var timeToMemorize : Int32 = 60
    
    var counterHasFinished = false
    var popUpIsInScene = false
    var isRecording = false
    
    var currentMode: gameMode!

    var swiftTimer = Timer()
    var swiftCounter = 60
    
    let time = 30
    let currentTime = 30
    
    var countdownTime = 45.0
    var ckTime = 45
    
    var isShowingContinue = false
    
    var timeLabel = SKLabelNode()
    var scoreLabel = AnimatedScoreLabel(text: "Score", score: 0, size: 25, color: UIColor(rgba: "#e74c3c"))
    var numbersTap = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    var mostTappedLabel = SKLabelNode(fontNamed: k.Montserrat.Light)
    var mostLabel = AnimatedScoreLabel(text: "Score", score: 0, size: 20, color: k.flatColors.red)
    var mostCound = 0
    
    var tapOnLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let numberLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    
    let circularTimer = ProgressNode()
    var gameTimer = Timer()
    var timer = Timer()
    
    var shortestTimer = Timer()
    var shortestTimeCounter = 0
    
    var longestTimer = Timer()
    var longestTimeCounter = 0
    
    var gameCounter: CGFloat = 0.0
    var pro : CGFloat = 0.0
    var hasGameEnded = false
    
    var progressTimer = Timer()
    var lastProg : Double = 0.0
    
    let background = SKSpriteNode(imageNamed: "background")
    let share = SKSpriteNode(imageNamed: NSLocalizedString("share", comment: "share-button"))
    let removeAds = SKSpriteNode(imageNamed: NSLocalizedString("removeAds", comment: "remove-ads"))
    let gameCenter =  SKSpriteNode(imageNamed: NSLocalizedString("gameCenter", comment: "game-center"))
    let recentScore = SKSpriteNode(imageNamed: NSLocalizedString("score", comment: "score"))
    let beginGame = SKSpriteNode(imageNamed: NSLocalizedString("beginGame", comment: "begin-game"))
    let home = SKSpriteNode(imageNamed: "home")
    let sound = SKSpriteNode(imageNamed: "sound")
    let info = SKSpriteNode(imageNamed: "info")
    
    let pause = SKSpriteNode(imageNamed: "pause")
    let replay = SKSpriteNode(imageNamed: "replay")
    let record = SKSpriteNode(imageNamed: "record")
    let homeButton = SKSpriteNode(imageNamed: "home")
    let no = SKSpriteNode(imageNamed: "no-img".localized)
    let free = SKSpriteNode(imageNamed: NSLocalizedString("free", comment: "free-button"))
    let continueLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let continueCountLabel = SKLabelNode(fontNamed: "Montserrat-Light")
    var continueTimer = Timer()
    
    let countdown = CountdownNode(texture: nil, color: UIColor.clear, size: CGSize(width: 0, height: 0))
    var popUp : SKSpriteNode!
    var countdownTimer = Timer()
    var minuteTime = Timer()
    
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
    var timerArray = [Timer]()
    
    lazy var priceFormatter: NumberFormatter = {
        let pf = NumberFormatter()
        pf.formatterBehavior = .behavior10_4
        pf.numberStyle = .currency
        return pf
    }()
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        setUpListners()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.productPurchased), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(productCancelled), name: NSNotification.Name(rawValue: "cancelled"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.rewardUser(_:)), name: NSNotification.Name(rawValue: "videoRewarded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.counterComplete), name: NSNotification.Name(rawValue: "counter"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene.setPaused), name: NSNotification.Name(rawValue: "pauseGame"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startRecording), name: NSNotification.Name(rawValue: k.NotificationCenter.RecordGameplay), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGameMode), name: NSNotification.Name(rawValue: kPlayGameModeNotification), object: nil)

        products = []
        Products.store.requestProducts{success, products in
            if success {
                self.products = products!
            }
        }
        UserDefaults.standard.set(false, forKey: "nk")

        randomWord()
        
        if let _ = UserDefaults.standard.object(forKey: "hasRemovedAds") as? Bool {
            FTLogging().FTLog("all ads are gone")
            
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "hideBanner"), object: nil)
        }

        size = CGSize(width: 640, height: 960)
        backgroundColor = UIColor(red: 40, green: 40, blue: 40, alpha: 1)
        scaleMode = .aspectFill
        
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = self.size
        background.zPosition = -10
        addChild(background)
        
        currentMode = .Endless
        
        GameModeHelper.sharedHelper.pausePointsCheck()
        
        initScene(currentMode, time: nil)
    }
    
    //MARK: Init Methods
    func setToRecord(_ toRecord: Bool) {
        recording = toRecord
    }
    
    func setupScene (_ mode : gameMode) {
        score = 0
        swiftCounter = 0
        gameCounter = 30
        
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
        
        if mode == .Endless {
            self.tapOnLabel.fontColor = UIColor.white
            self.tapOnLabel.fontSize = 30
            self.tapOnLabel.text = "TAP NUMBER:"
            self.tapOnLabel.horizontalAlignmentMode = .center
            self.tapOnLabel.verticalAlignmentMode = .center
            self.tapOnLabel.position = CGPoint(x: self.frame.midX - 25, y: -90)
            self.addChild(self.tapOnLabel)
            
            self.number = self.randomNumber()
            
            self.numberLabel.fontColor = UIColor(rgba: "#e74c3c")
            self.numberLabel.fontSize = 38
            self.numberLabel.text = String(self.number)
            self.numberLabel.horizontalAlignmentMode = .center
            self.numberLabel.verticalAlignmentMode = .center
            self.numberLabel.position = CGPoint(x: self.tapOnLabel.position.x + 130, y: -90)
            self.addChild(self.numberLabel)
            
            self.startCountdown()
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
        
        if mode == .FirstLaunch {
            createTutorial(tutorialWithNumber: 1)
        }
        
        if mode == .Easy  {
            if !UserDefaults.keyAlreadyExists(kEasyKey) {
                UserDefaults.standard.set(true, forKey: kEasyKey)
                
                let alert = PMAlertController(title: "Welcome to Easy Mode", description: "Hey! This is easy mode. Easy mode is super well... Easy! \r\n\r\nIt's the same as Endless but instead of 45 seconds, you've a whole minute... PER ROUND! Isn't that amazing? \r\n\r\nHow about we get started?", image: nil, style: .alertWithBlur)
                alert.addAction(PMAlertAction(title: "Let's Go!", style: .default, action: {
                    self.startCountdown()
                }))
                
                alert.addAction(PMAlertAction(title: "Nah..", style: .cancel, action: {
                    let gModes = GameModes()
                    self.view?.presentScene(gModes, transition: SKTransition.crossFade(withDuration: 1))
                }))
                
                self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                startCountdown()
            }
        }
        
        if mode == .Impossible {
            if !UserDefaults.keyAlreadyExists(kImpossibleKey) {
                UserDefaults.standard.set(true, forKey: kImpossibleKey)
                
                let alert = PMAlertController(title: "Welcome to Impossible Mode", description: "Hey! This is Impossible mode. Impossible mode is super well... IMPOSSIBLE. \r\n\r\nIt's the same as Endless but instead of 45 seconds, you've only have, drumroll please.... 30 Seconds! Isn't that crazy? \r\n\r\nHow about we get started?", image: nil, style: .alertWithBlur)
                alert.addAction(PMAlertAction(title: "Let's Go!", style: .default, action: {
                    self.startCountdown()
                }))
                
                alert.addAction(PMAlertAction(title: "Nah..", style: .cancel, action: {
                    let gModes = GameModes()
                    self.view?.presentScene(gModes, transition: SKTransition.crossFade(withDuration: 1))
                }))
                
                self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                startCountdown()
            }

        }
    }
    
    func setGameMode(_ mode: gameMode) {
        currentMode = mode
    }
    
    func startCountdown() {
        self.countdown.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.countdown.zPosition = 10
        self.addChild(self.countdown)
        
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countdownCheck), userInfo: nil, repeats: true)
        self.timerArray.append(self.countdownTimer)
        
        let dbackground = SKSpriteNode(imageNamed: "background")
        dbackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        dbackground.size = self.size
        dbackground.alpha = 0.8
        dbackground.name = "bg"
        dbackground.zPosition = 9
        self.addChild(dbackground)
        
        if recording {
            startRecording()
        }
    }
    
    func createTutorial(tutorialWithNumber number: Int) {
        
        if number == 1 {
            let tut1 = TutorialBox(withType: .Regular, lineOne: "Find this number", lineTwo: nil, lineThree: nil, fontSize : 16)
            tut1.position = CGPoint(x: numberLabel.position.x, y: numberLabel.position.y + 250)
            tut1.zPosition = 25
            tut1.name = "tut" + String(number)
            addChild(tut1)
            
            tut1.bounce()
        }
        
        else if number == 2 {
            let tut2 = TutorialBox(withType: .Regular, lineOne: "Tap Me!", lineTwo: nil, lineThree: nil, fontSize : 16)
            tut2.position = CGPoint(x: numberLabel.position.x, y: numberLabel.position.y + 250)
            tut2.zPosition = 25
            tut2.name = "tut" + String(number)
            addChild(tut2)
            
            tut2.bounce()
        }
    }
    
    func initScene(_ mode: gameMode, time: Int?) {
        
        if mode == .Timed {
            
            setupScene(mode)
            
            for box in  boxArray {
                box.scale()
            }
            
            currentMode = .Timed
            
            FTLogging().FTLog("\n current game mode is Times \n")
            
            /*let timerSpace = SKTexture(imageNamed: "timerSpace")
            self.circularTimer.position = CGPointMake(self.numberBox4.position.x, 850)
            self.circularTimer.zPosition = 8
            self.circularTimer.radius = timerSpace.size().width / 2
            self.circularTimer.width = 8.0
            self.circularTimer.zPosition = 2
            self.circularTimer.color = UIColor(rgba: "#e74c3c")
            self.circularTimer.backgroundColor = UIColor(rgba: "#434343")
            
            self.addChild(self.circularTimer)*/
            
            numbersTap.text = "NUMBERS TAPPED"
            numbersTap.position = CGPoint(x: (scoreLabel?.position.x)! + 15, y: (scoreLabel?.position.y)!)
            numbersTap.horizontalAlignmentMode = .left
            numbersTap.fontColor = UIColor.white
            numbersTap.fontSize = 25
            numbersTap.zPosition = (scoreLabel?.zPosition)!
            addChild(numbersTap)
            
        } else {
            
            setupScene(mode)
            
            currentMode = mode
            
            for box in  boxArray {
                box.scale()
            }
            
            FTLogging().FTLog("\n current game mode is Endless \n")
            
            let timerSpace = SKTexture(imageNamed: "timerSpace")
            self.circularTimer.position = CGPoint(x: self.numberBox4.position.x, y: 850)
            self.circularTimer.radius = timerSpace.size().width / 2
            self.circularTimer.width = 8.0
            self.circularTimer.zPosition = 2
            self.circularTimer.color = UIColor(rgba: "#e74c3c")
            self.circularTimer.backgroundColor = UIColor(rgba: "#434343")
            
            self.addChild(self.circularTimer)
            
            scoreLabel?.position = CGPoint(x: circularTimer.position.x - 320, y: circularTimer.position.y - 10)
            scoreLabel?.horizontalAlignmentMode = .left
            scoreLabel?.fontColor = UIColor(rgba: "#e74c3c")
            addChild(scoreLabel!)
            
            numbersTap.text = "NUMBERS TAPPED"
            numbersTap.position = CGPoint(x: (scoreLabel?.position.x)! + 15, y: (scoreLabel?.position.y)!)
            numbersTap.horizontalAlignmentMode = .left
            numbersTap.fontColor = UIColor.white
            numbersTap.fontSize = 25
            numbersTap.zPosition = (scoreLabel?.zPosition)!
            addChild(numbersTap)
            
            mostLabel?.position = CGPoint(x: (scoreLabel?.position.x)!, y: (scoreLabel?.position.y)! - 30)
            mostLabel?.horizontalAlignmentMode = .left
            mostLabel?.fontColor = k.flatColors.red
            mostLabel?.score = Int32(UserDefaults.standard.highScore)
            mostLabel?.text = ""
            addChild(mostLabel!)
            
            mostTappedLabel.position = CGPoint(x: mostLabel!.position.x + 20, y: mostLabel!.position.y)
            mostTappedLabel.fontSize = mostLabel!.fontSize
            mostTappedLabel.fontColor = UIColor.white
            mostTappedLabel.horizontalAlignmentMode = .left
            mostTappedLabel.zPosition = mostLabel!.zPosition
            mostTappedLabel.text = "MOST TAPPED"
            addChild(mostTappedLabel)

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
    
    func randomArray(_ array: [Int]) -> () -> Int {
        var numbers: [Int] = []
        return {
            if array.count == 0 {
                numbers = array
            }
            
            let index = Int(arc4random_uniform(UInt32(numbers.count)))
            return numbers.remove(at: index)
        }
    }
    
    func randomWord() {
        
        let getRandom = randomSequenceGenerator(1, max: 99)
        for _ in 1...24 {
            array.append(getRandom());
            
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
    
    func countdownCheck() {
        
        countdown.counterUpdate()
    }
    
    func counterComplete () {
        countdownTimer.invalidate()
        countdown.run(SKAction.fadeAlpha(to: 0, duration: 1), completion: {
            self.countdown.removeFromParent()
            self.childNode(withName: "bg")?.removeFromParent()
            
            if self.currentMode != .Memory {
                

                
                if self.currentMode == .Easy {
                    self.circularTimer.countdown(60) { (Void) in
                        self.gameEnd(false)
                    }
                };
                
                if self.currentMode == .Impossible {
                    self.circularTimer.countdown(30) { (Void) in
                        self.gameEnd(false)
                    }
                };
                
                if self.currentMode == .Endless {
                    self.circularTimer.countdown(TimeInterval(self.ckTime)) { (Void) in
                        self.timer = Timer.every(1, {
                            if self.ckTime < 0 {
                                self.ckTime -= 1
                            }
                        })
                        self.gameEnd(false)
                    }
                };
                
                //self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.gameTimerCheck), userInfo: nil, repeats: true)
                self.timerArray.append(self.gameTimer)
                
            }
            
            self.counterHasFinished = true
            
            self.shortestTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCurrentGameTime), userInfo: nil, repeats: true)
            self.timerArray.append(self.shortestTimer)
            
            self.longestTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCurrentGameTime), userInfo: nil, repeats: true)
            self.timerArray.append(self.longestTimer)
        })

    }
    
    func updateCurrentGameTime() {
        shortestTimeCounter += 1
        longestTimeCounter += 1
    }
    
    func secondsToHoursMinutesSeconds(_ seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func productCancelled() {
        loadingNotification.hide(animated: true)
    }

    //MARK: Scoring Methods/Scene Methods
    
    func setPaused() {
        FTLogging().FTLog("Pause")
    }
    
    func gameEnd(_ showOther : Bool) {
        UserDefaults.standard.set(Float(circularTimer.progress), forKey: "lastProgress")
        circularTimer.stopCountdown()
        timer.invalidate()
        longestTimer.invalidate()
        
        GCHelper.sharedGameKitHelper.reportLeaderboardIdentifier(k.GameCenter.Leaderboard.TopScorers, score: numbersTapped)
        GCHelper.sharedGameKitHelper.reportLeaderboardIdentifier(k.GameCenter.Leaderboard.LongestRound, score: longestTimeCounter)
        GCHelper.sharedGameKitHelper.checkIfAchivement()
        
        let dbackground = SKSpriteNode(imageNamed: "background")
        dbackground.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        dbackground.size = self.size
        dbackground.name = "whiteBG"
        dbackground.alpha = 0.9
        dbackground.zPosition = 3
        if self.children.contains(dbackground) {} else { addChild(dbackground) }
        
        let def = UserDefaults.standard
        if let _ = def.object(forKey: "hasRemovedAds") as? Bool {
            FTLogging().FTLog("all ads are gone")
            
        }
        
        if UserDefaults.keyAlreadyExists(kNumbersKey) {
            let oldAmount = UserDefaults.standard.integer(forKey: kNumbersKey)
            let newAmount : Int = oldAmount + numbersTapped
            
            UserDefaults.standard.set(newAmount, forKey: kNumbersKey)
        } else {
            UserDefaults.standard.set(0, forKey: kNumbersKey)
        }
        
        let videoSaveDefault = UserDefaults.standard.integer(forKey: "videoSave")
        var videoSave = 1
        
        if videoSaveDefault == 0 {
            addContinue()
        } else {
            addStuff()
            videoSave -= 1
            UserDefaults.standard.set(videoSave, forKey: "videoSave")
        }
    }
    
    func addStuff() {
        
        GameModeHelper.sharedHelper.resetPointsCheck()
        UserDefaults.standard.highScore = numbersTapped
        
        for box in boxArray {
            box.isUserInteractionEnabled = false
        }
        
        recentScore.setScale(1.12)
        recentScore.name = "recentScore"
        recentScore.position = CGPoint(x: self.frame.midX - 100, y: self.frame.midY)
        recentScore.zPosition = 4
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
        gameCenter.zPosition = 4
        if self.children.contains(gameCenter) {} else { addChild(gameCenter) }
        
        removeAds.name = "removeAds"
        removeAds.position = CGPoint(x: gameCenter.position.x - 50, y: gameCenter.position.y + 140)
        removeAds.zPosition = 4
        removeAds.setScale(0.2)
        if self.children.contains(removeAds) {} else { addChild(removeAds) }
        
        removeAds.run(SKAction.scale(to: 1, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        share.name = "share"
        share.position = CGPoint(x: removeAds.position.x  - 20, y: removeAds.position.y - 270)
        share.zPosition = 4
        share.setScale(0.4)
        if self.children.contains(share) {} else { addChild(share) }
        
        share.run(SKAction.scale(to: 1, duration: 0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        beginGame.name = "beginGame"
        beginGame.position = CGPoint(x: self.frame.midX, y: -90)
        beginGame.zPosition = 4
        if self.children.contains(beginGame) {} else { addChild(beginGame) }
        
        beginGame.run(SKAction.moveTo(y: 90, duration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        var arr = [SKSpriteNode]()
        
        home.name = "home"
        home.position = CGPoint(x: self.frame.midX + 145, y: 150)
        home.zPosition = 7
        home.alpha = 1
        home.setScale(0)
        if self.children.contains(home) {} else { addChild(home) }

        
        info.name = "home"
        info.position = CGPoint(x: home.position.x - 50, y: home.position.y)
        info.zPosition = 7
        info.alpha = 1
        info.setScale(0)
        if self.children.contains(info) {} else { addChild(info) }

        
        sound.name = "home"
        sound.position = CGPoint(x: info.position.x - 50, y: home.position.y)
        sound.zPosition = 7
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
        gameOverText.zPosition = 22
        gameOverText.text = "game over"
        gameOverText.name = "gameOver"
        gameOverText.fontSize = 55
        gameOverText.position = CGPoint(x: self.frame.midX, y: removeAds.position.y + 1000)
        if self.childNode(withName: "gameOver") != nil {
            addChild(gameOverText)
        }
        
        gameOverText.run(SKAction.moveTo(y: removeAds.position.y + 140, duration: 1))
        
        hasRun = 1
        isShowingContinue = false
        hasGameEnded = true
        
        if rater == false {
            Appirater.userDidSignificantEvent(true)
            rater = true
        }

    
    if isRecording || recording {
        stopRecording()
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
    
    func addContinue () {
        if Reachability.isConnectedToNetwork() {
            
            var count = 5
            
            continueLabel.position = CGPoint(x: 327, y: 687)
            continueLabel.fontColor = UIColor.white
            continueLabel.zPosition = 33
            continueLabel.horizontalAlignmentMode = .center
            continueLabel.text = NSLocalizedString("continue", comment: "continue")
            continueLabel.fontSize = 75
            if self.children.contains(continueLabel) {} else { addChild(continueLabel) }
            
            continueCountLabel.position = CGPoint(x: 327, y: 608)
            continueCountLabel.fontColor = UIColor.white
            continueCountLabel.zPosition = 33
            continueCountLabel.horizontalAlignmentMode = .center
            continueCountLabel.fontSize = 75
            continueCountLabel.text = String(count)
            if self.children.contains(continueCountLabel) {} else { addChild(continueCountLabel) }
            
            free.position = CGPoint(x: 255, y: 431)
            free.zPosition = continueLabel.zPosition
            if self.children.contains(free) {} else { addChild(free) }
            
            no.position = CGPoint(x: 380, y: 431)
            no.zPosition = continueLabel.zPosition
            if self.children.contains(no) {} else { addChild(no) }
            
            continueArray.append(continueCountLabel)
            continueArray.append(continueLabel)
            continueArray.append(free)
            continueArray.append(no)
            
            for node in continueArray {
                node.alpha = 1
            }
                
            isShowingContinue = true
            
            continueTimer = Timer.every(1, {
                if count > 0 {
                    count -= 1
                    self.continueCountLabel.text = String(count)
                } else {
                    self.continueTimer.invalidate()
                    self.continueCountLabel.text = "0"
                    for node in self.continueArray {
                        node.run(SKAction.fadeOut(withDuration: 0.2))
                    }
                    
                    self.addStuff()
                }
            })
            
        } else {
            addStuff()
        }
        
        
    }

    func clearScene() {
        
        removeAds.run(SKAction.moveTo(y: -1000, duration: 2.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        recentScore.run(SKAction.moveTo(y: -1000, duration: 2.1, delay: 1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        beginGame.run(SKAction.moveTo(y: -1000, duration: 2.2, delay: 2, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        share.run(SKAction.moveTo(y: -1000, duration: 2.4, delay: 1.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        
        gameCenter.run(SKAction.moveTo(y: -1000, duration: 2, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)) {
            
            self.childNode(withName: "whiteBG")?.removeFromParent()
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
            
            for box in self.boxArray {
                box.isPaused = false
            }
            
            self.hasGameEnded = false
            self.rater = false
            
            self.resetScene()

        }
        
    }
    
    func resetScene() {
        
        shortestTimer.invalidate()
        GCHelper.sharedGameKitHelper.reportLeaderboardIdentifier(k.GameCenter.Leaderboard.ShortestTimes, score: shortestTimeCounter)
        
        array.removeAll()
        randomWord()
        
        hasRun = 0
        
        numberBox1.indexs = array[0]
        numberBox2.indexs = array[1]
        numberBox3.indexs = array[2]
        numberBox4.indexs = array[3]
        numberBox5.indexs = array[4]
        numberBox6.indexs = array[5]
        numberBox7.indexs = array[6]
        numberBox8.indexs = array[7]
        numberBox9.indexs = array[8]
        numberBox10.indexs = array[9]
        numberBox11.indexs = array[10]
        numberBox12.indexs = array[11]
        numberBox13.indexs = array[12]
        numberBox14.indexs = array[13]
        numberBox15.indexs = array[14]
        numberBox16.indexs = array[15]
        numberBox17.indexs = array[16]
        numberBox18.indexs = array[17]
        numberBox19.indexs = array[18]
        numberBox20.indexs = array[19]
        numberBox21.indexs = array[20]
        numberBox22.indexs = array[21]
        numberBox23.indexs = array[22]
        numberBox24.indexs = array[23]
        
        for box in boxArray {
            box.alpha = 1
            box.update()
        }
        
        for numberBox in boxArray {
            numberBox.normal()
        }
        
        number = randomNumber()
        numberLabel.text = "\(number)"
        
        self.circularTimer.stopCountdown()
        self.circularTimer.countdown(countdownTime) { (Void) in
            self.gameEnd(false)
        }
        
    }
    
    func loose() {
        
        gameEnd(false)
    }
    
    func point() {
        
        number = randomNumber()
        numberLabel.text = String(number)
        
        timeLabel.removeAllActions()
        
        var highScore = UserDefaults.standard.highScore
        if numbersTapped > highScore {
            print("There is a new high score of: \(numbersTapped) and a saved high score of: \(highScore)")
            highScore = numbersTapped
            mostLabel?.score = Int32(highScore)
        } else {
            mostLabel?.score = Int32(numbersTapped)
        }
        
        numbersTapped += 1
        scoreLabel?.score = Int32(numbersTapped)
       
        
        if currentMode == .Timed {
            let pro = 0.5
            self.circularTimer.progress = CGFloat(pro)
        }
    }
    
    //MARK: In App Puchases Methods
    func restoreTapped() {
        Products.store.restorePurchases()
    }
    
    func purchaseProduct(_ index: Int) {
        if Reachability.isConnectedToNetwork() {
            let product = products[index]
            Products.store.buyProduct(product)
        } else {
            let vc = self.view?.window?.rootViewController
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Unable to purchase product. Please connect to the internet and try again", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                NSLog("Alert")
            })
            
            alert.addAction(action)
            vc!.present(alert, animated: true, completion: nil)
            
        }

    }
      
    func productPurchased(_ notification: Notification) {
        loadingNotification.hide(animated: true)
        let productIdentifier = notification.object as! String
        for (_, product) in products.enumerated() {
            if product.productIdentifier == productIdentifier {
                FTLogging().FTLog("product purchased with id \(productIdentifier) & \(product.productIdentifier)")
                if productIdentifier == Products.RemoveAds {
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "hasRemovedAds")
                    
                    //NSNotificationCenter.defaultCenter().postNotificationName("areAdsGone", object: self)
                }
                break
            }
        }
    }
    
    //MARK: Other Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.location(in: self)

            handleTouchedPoint(location)
        }
    }
    
    func handleTouchedPoint(_ location: CGPoint) {
        
        let node = self.atPoint(location)
        
        if isShowingContinue {
            if no.contains(location) {
                continueTimer.invalidate()
                
                for node in continueArray {
                    //node.runAction(SKAction.fadeOutWithDuration(1))
                    node.removeFromParent()
                    addStuff()
                }
                
            };
            
            if free.contains(location) {
                if Supersonic.sharedInstance().isAdAvailable() {
                    self.continueTimer.invalidate()
                    Supersonic.sharedInstance().showRV(withPlacementName: "Game_Over")
                }
            }
        }
        
        if hasGameEnded && isShowingContinue != true {
            if gameCenter.contains(location) {
                FTLogging().FTLog("game center")
                
                gameCenter.run(k.Sounds.blopAction1)
                
                let vC = self.view!.window?.rootViewController
                GCHelper.sharedGameKitHelper.showGameCenter(vC!, viewState: .default)
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
                    self.loadingNotification = MBProgressHUD.showAdded(to: self.view!, animated: true)
                    self.loadingNotification.mode = .indeterminate
                    self.loadingNotification.label.text = "Loading"
                    self.loadingNotification.isUserInteractionEnabled = false
                    
                    NSLog("You pressed button one")
                    
                } // 2
                let restorePurchases = UIAlertAction(title: "Restore Purchases", style: .default, handler: { (UIAlertAction) in
                    self.restoreTapped()
                })
                
                alert.addAction(firstAction) // 4
                alert.addAction(restorePurchases)
                vc!.present(alert, animated: true, completion:nil) // 6
            }
            
            if share.contains(location) {
                FTLogging().FTLog("share")
                
                share.run(k.Sounds.blopAction1)
                
                let textToShare = "I just tapped \(numbersTapped) tiles in a FREE game called 'Number Tap' that's made by a 13-YEAR-OLD! Download Today!"
                
                let objectsToShare = [textToShare] as [Any]
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
                loadingNotification.label.text = "Loading"
                loadingNotification.isUserInteractionEnabled = false
                
                removeAds.run(k.Sounds.blopAction1)
                purchaseProduct(0)
            }
            
            if beginGame.contains(location) {
                FTLogging().FTLog("begin game")
                beginGame.run(k.Sounds.blopAction1)
                clearScene()
            }
            
        }
        
        if home.contains(location) {
            FTLogging().FTLog("home")
            let homeScene = HomeScene()
            self.view?.presentScene(homeScene, transition: SKTransition.fade(with: UIColor(rgba: "#434343"), duration: 2))
        };
        
        if pause.contains(location) {
            FTLogging().FTLog("pause")
        };
        
        if record.contains(location) {
            FTLogging().FTLog("record")
            startRecording()
        };
        
        if replay.contains(location) {
            FTLogging().FTLog("replay")
            resetScene()
        };
        
        
        if hasRun == 0 && counterHasFinished && isShowingContinue == false{
            
            for box in boxArray {
                if box.contains(location) {
                    playSound(fileName: k.Sounds.blop01, onSprite: box)
                    
                    if box.indexs == number {
                        FTLogging().FTLog ("point")
                        point()
                    } else {
                        FTLogging().FTLog("loose")
                        loose()
                    }
                    
                    if box.currentState != .used {
                        box.used()
                    }
                }
            }
            
      }
        
        if currentMode == .FirstLaunch {
            if node.name == "tut1" {
                let tutorial = node as! TutorialBox
                
                let scale = SKAction.scale(to: 0.005, duration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
                tutorial.run(scale) {
                    
                }
            }
        }

    }
    
    override func pauseGame() {
        super.pauseGame()
        
        self.view?.isPaused = true
        
        let visualEffect = UIBlurEffect(style: .dark)
        ablurView = UIVisualEffectView(effect: visualEffect)
        ablurView.frame = (view?.bounds)!
        ablurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view?.addSubview(ablurView)
        
        counterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        counterLabel.center = CGPoint(x: view!.bounds.midX, y: view!.bounds.midY + 25)
        counterLabel.textAlignment = NSTextAlignment.center
        counterLabel.text = "3"
        counterLabel.font = UIFont(name: k.Montserrat.Regular, size: 42)
        counterLabel.textColor = UIColor.white
        counterLabel.alpha = 0
        self.view?.addSubview(counterLabel)
        
        pauseLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        pauseLabel.center = CGPoint(x: view!.bounds.midX, y: view!.bounds.midY + 65) // +40
        pauseLabel.textAlignment = NSTextAlignment.center
        pauseLabel.text = "Game Paused"
        pauseLabel.font = UIFont(name: k.Montserrat.Light, size: 22)
        pauseLabel.textColor = UIColor.white
        pauseLabel.alpha = 0
        self.view?.addSubview(pauseLabel)

    }
    
    override func unPauseGame(completionOfAnimation: @escaping () -> ()) {
        super.unPauseGame(completionOfAnimation: completionOfAnimation)
        UIView.animate(withDuration: 2, animations: {
            self.counterLabel.center = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY)
            self.counterLabel.alpha = 1
            
            self.pauseLabel.center = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY + 40)
            self.pauseLabel.alpha = 1
            
            }, completion: { (value: Bool) in
                
                var counter = 3
                self.pausedTimer = Timer.every(1, {
                    if counter == 0 {
                        self.counterLabel.text = "0"
                        self.pausedTimer.invalidate()
                        self.animate(completionOfAnimation: completionOfAnimation)
                    } else {
                        counter -= 1
                        self.counterLabel.text = String(counter)
                    }
                    
                })
        })
    }
    
    override func animate(completionOfAnimation: @escaping () -> ()) {
        super.animate(completionOfAnimation: completionOfAnimation)
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            
            UIView.animate(withDuration: 1, animations: {
                self.counterLabel.alpha = 0
                self.counterLabel.center = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY - 25)
                
                self.pauseLabel.alpha = 0
                self.pauseLabel.center = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY - 40)
                
                self.ablurView.alpha = 0
                
                }, completion: { (value: Bool) in
                    self.counterLabel.removeFromSuperview()
                    self.ablurView.removeFromSuperview()
                    self.pauseLabel.removeFromSuperview()
                    
                    completionOfAnimation()
            })
        }
    }
    
    func stopRecording() {
        let vC = self.view?.window?.rootViewController
        RPScreenRecorder.shared().stopRecording { (previewController: RPPreviewViewController?, error: Error?) -> Void in
            if previewController != nil {
                let alertController = UIAlertController(title: "Recording", message: "Do you wish to discard or view your gameplay recording?", preferredStyle: .alert)
                
                let discardAction = UIAlertAction(title: "Discard", style: .default) { (action: UIAlertAction) in
                    RPScreenRecorder.shared().discardRecording(handler: { () -> Void in
                        // Executed once recording has successfully been discarded
                    })
                }
                
                let viewAction = UIAlertAction(title: "View", style: .default, handler: { (action: UIAlertAction) -> Void in
                    vC!.present(previewController!, animated: true, completion: nil)
                })
                
                alertController.addAction(discardAction)
                alertController.addAction(viewAction)
                
                vC!.present(alertController, animated: true, completion: {
                    print("Presented recording")
                })
                
            } else {
                // Handle error
                print("Error in recording")
            }
        }
    }
    
    func startRecording() {
        if RPScreenRecorder.shared().isAvailable {
            RPScreenRecorder.shared().startRecording(withMicrophoneEnabled: true, handler: { (error: Error?) -> Void in
                if error == nil { // Recording has started
                    self.isRecording = true
                    print("Recording")
                } else {
                    // Handle error
                    self.isRecording = false
                }
            })
        } else {
            // Display UI for recording being unavailable
            self.isRecording = false
            let vc = self.view?.window?.rootViewController
            let alert = UIAlertController(title: "Recording Unavaliable", message: "Your device does not support recording!", preferredStyle: .alert) // 1
            let firstAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) -> Void in
                FTLogging().FTLog("You pressed button one")
           }
            
            alert.addAction(firstAction) // 4
            vc!.present(alert, animated: true, completion:nil) // 6
            
        }
    }
    
    func scaleForiPadMini(_ node : SKSpriteNode, scale : CGFloat) {
        if UIScreen.main.isRetina() {
            node.setScale(scale)
        }
    }
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWithError error: Error, previewViewController: RPPreviewViewController?) {
        
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        let vC = self.view?.window?.rootViewController
        vC!.dismiss(animated: true, completion: nil)
    }
    
    func playSound(fileName sound: String, onSprite node: SKNode?) {
        let defaults = UserDefaults.standard
        let isSoundEnabled = defaults.bool(forKey: "isSoundEnabled")
        
        let soundAction = SKAction.playSoundFileNamed(sound, waitForCompletion: false)
        
        if (isSoundEnabled != nil) {
            node!.run(soundAction, completion: { 
                FTLogging().FTLog("\n Played sound with file named \r\n \(sound) \n")
            })
        } else {
            FTLogging().FTLog("\n Sound is disabled \n")
        }
    }
   
    func rewardUser(_ notification : Notification) {
        
        let videoSaveDefault = UserDefaults.standard.integer(forKey: "videoSave")
        var videoSave = 0
        
        if videoSaveDefault == 0 {
            videoSave += 1
            UserDefaults.standard.set(videoSave, forKey: "videoSave")
        }
        
        for node in continueArray {
            node.removeFromParent()
            self.childNode(withName: "whiteBG")?.removeFromParent()
        }
        
        continueTimer.invalidate()
        isShowingContinue = false
        
        let prog = UserDefaults.standard.float(forKey: "lastProgress")
        
        if prog == 0.0 {
            self.circularTimer.progress = CGFloat(prog + 0.11111111)
            self.circularTimer.countdown(TimeInterval(self.ckTime - 5)) { (Void) in
                self.gameEnd(true)
            }
        } else {
            self.circularTimer.progress = CGFloat(prog)
            self.circularTimer.countdown(TimeInterval(self.ckTime)) { (Void) in
                self.gameEnd(true)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        var highScore = UserDefaults.standard.highScore
        if numbersTapped > highScore {
            print("There is a new high score of: \(numbersTapped) and a saved high score of: \(highScore)")
            highScore = numbersTapped
            mostLabel?.score = Int32(highScore)
        } else {
            mostLabel?.score = Int32(numbersTapped)
        }
        
        
    }
}

