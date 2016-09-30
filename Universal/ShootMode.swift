//
//  ShootMode.swift
//  Number Tap
//
//  Created by jesse on 05/07/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit

struct Physics {
    static let Box : UInt32 = 0x1 << 0
    static let Bullet : UInt32 = 0x1 << 1
    static let Ball : UInt32 = 0x1 << 2
}

let kHasPlayedShoot = "hasPlayedShootModez"

class Shoot : BaseScene, SKPhysicsContactDelegate {
    let mainBall = SKShapeNode(circleOfRadius: 75)
    let shotNumberLabel: AnimatedScoreLabel = AnimatedScoreLabel(text: "", score: 0, size: 36, color: k.flatColors.red)
    let numbersShotLabel = SKLabelNode(fontNamed: k.Montserrat.SemiBold)
    let secondsLabel = SKLabelNode(fontNamed: k.Montserrat.Regular)
    let millisecondsLabel = SKLabelNode(fontNamed: k.Montserrat.Regular)

    var boxTimer = Timer()
    var scoreTimer = Timer()
    var gameTimer = Timer()
    var timeArray: [Timer] = [Timer]()
    var stopwatchTimer : Timer?
    var visibleBoxTimer = Timer()

    var hits = 3
    var index = 0
    var length = 3.0
    var numbersShot = 0
    var startDate : Date!
    
    var hasGameStarted = false
    var visibleBoxesArray = [NumberBox]()
    var snapshot = UIImage()
    
    //TODO: Configure sharing to take screenshot and work well.
    override func didMove(to view: SKView) {
        //TODO: Change it to save the boolean in NSUserDefaults
        if UserDefaults.keyAlreadyExists(kHasPlayedShoot) == false {
            showShootAlert()
        } else {
            startTheGame()
        }
    }
    
    func startTheGame() {
        physicsWorld.contactDelegate = self
        view!.showsPhysics = false
        size = CGSize(width: 640, height: 960)
        scaleMode = .aspectFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(counterIsComplete), name: NSNotification.Name(rawValue: k.NotificationCenter.Counter), object: nil)
        
        randomWord()
        
        mainBall.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        mainBall.fillColor = k.flatColors.red
        mainBall.strokeColor = UIColor.clear
        mainBall.zPosition = 10.0
        mainBall.name = "ball"
        
        mainBall.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        mainBall.physicsBody?.categoryBitMask = Physics.Ball
        mainBall.physicsBody?.contactTestBitMask = Physics.Box
        mainBall.physicsBody?.collisionBitMask = Physics.Box
        mainBall.physicsBody?.affectedByGravity = false
        mainBall.physicsBody?.isDynamic = false
        addChild(mainBall)
        
        shotNumberLabel.score = Int32(numbersShot)
        shotNumberLabel.horizontalAlignmentMode = .left
        shotNumberLabel.position = CGPoint(x: 90,y: 890)
        shotNumberLabel.fontColor = k.flatColors.red
        shotNumberLabel.zPosition = 10.0
        addChild(shotNumberLabel)
        
        numbersShotLabel.text = NSLocalizedString("numbers-shot", comment: "Numbers Shot")
        numbersShotLabel.fontSize = shotNumberLabel.fontSize
        numbersShotLabel.fontColor = UIColor.white
        numbersShotLabel.horizontalAlignmentMode = .left
        numbersShotLabel.position = CGPoint(x: shotNumberLabel.position.x + 20, y: shotNumberLabel.position.y)
        numbersShotLabel.zPosition = 10.0
        addChild(numbersShotLabel)
        
        secondsLabel.position = CGPoint(x: shotNumberLabel.position.x - 10, y: shotNumberLabel.position.y - 40)
        secondsLabel.horizontalAlignmentMode = .left
        secondsLabel.text = "00:00:00"
        secondsLabel.fontSize = 26
        secondsLabel.fontColor = UIColor.white
        secondsLabel.zPosition = 10.0
        addChild(secondsLabel)
        
        startCountDown()
    }
    
    func showShootAlert() {
        let alert = PMAlertController(title: "Welcome to Shoot!", description: "Hey, this is Shoot Mode in Number Tap! Shoot all the numbers and keep the ball safe. Avoid allowing the numbers attack the ball as it can be fatal.. \r\n\r\nThe aim is to shoot as many numbers as you can in the shortest amount of time but luckily time is infinite.\r\n\r\nAre you ready?", image: nil, style: .alertWithBlur)
        alert.addAction(PMAlertAction(title: "Let's Go!", style: .default, action: { 
            self.startTheGame()
        }))
        
        alert.addAction(PMAlertAction(title: "Nah..", style: .cancel, action: { 
            let gameModes = GameModes()
            let transition = SKTransition.crossFade(withDuration: 1)
            self.view?.presentScene(gameModes, transition: transition)
            self.removeAllActions()
            self.removeAllChildren()
            self.removeFromParent()
        }))
        
        let vc = self.view?.window?.rootViewController
        vc!.present(alert, animated: true, completion: nil)
        
        UserDefaults.standard.set(true, forKey: kHasPlayedShoot)
    }
    
    func setupGameTimers() {
        var five = Timer()
        five = Timer.every(0.001) {
            if self.numbersShot == 3 {
                print("5 Numbers Shot")
                self.changeTimer(2)
                five.invalidate()
            }
        }
        
        var eight = Timer()
        eight = Timer.every(0.001) {
            if self.numbersShot == 7 {
                print("8 Numbers Shot")
                self.changeTimer(1.5)
                eight.invalidate()
            }
        }
        
        var eleven = Timer()
        eleven = Timer.every(0.001) {
            if self.numbersShot == 11 {
                print("11 Numbers Shot")
                self.changeTimer(1.25)
                eleven.invalidate()
            }
        }
        
        var fifteen = Timer()
        fifteen = Timer.every(0.001) {
            if self.numbersShot == 15 {
                print("15 Numbers Shot")
                self.changeTimer(1)
                fifteen.invalidate()
            }
        }
        
        var seventeen = Timer()
        seventeen = Timer.every(0.001) {
            if self.numbersShot == 17 {
                print("17 Numbers Shot")
                self.changeTimer(0.9)
                seventeen.invalidate()
            }
        }
        
        var twentyone = Timer()
        twentyone = Timer.every(0.001) {
            if self.numbersShot == 21 {
                print("21 Numbers Shot")
                self.changeTimer(0.85)
                twentyone.invalidate()
            }
        }
        
        var thirty = Timer()
        thirty = Timer.every(0.001) {
            if self.numbersShot == 30 {
                print("30 Numbers Shot")
                self.changeTimer(0.8)
                thirty.invalidate()
            }
        }
        
        Timer.after(6, {
            if self.hasGameStarted {
                self.snapshot = self.view!.takeSnapshot()
            }
        })
        
        timerArray.append(five)
        timerArray.append(eight)
        timerArray.append(eleven)
        timerArray.append(fifteen)
        timerArray.append(seventeen)
        timerArray.append(twentyone)
        timerArray.append(thirty)
    }
    
    func changeTimer(_ time: Double) {
        boxTimer.invalidate()
        
        boxTimer = Timer.every(time, {
            self.spawnNumbers(withDuration: time)
        })
    }
    
    func counterIsComplete(_ aNotification: Notification) {
        countdown.run(SKAction.fadeAlpha(to: 0, duration: 1), completion: {
            print("Removed")
            self.countdown.removeFromParent()
            self.childNode(withName: "bg")?.removeFromParent()
            
            self.gameBegin()
        })
        
    }
    
    func gameBegin() {
        if let box = self.childNode(withName: "box") as? NumberBox {
            box.removeFromParent()
        }
        
        for box in visibleBoxesArray {
            box.removeFromParent()
        }
        
        self.hasGameStarted = true
        
        self.boxTimer = Timer.every(self.length, {
            self.spawnNumbers(withDuration: 3.0)
        })
        
        startDate = Date()
        stopwatchTimer = Timer.every(1.0/1.0, {
            let currentDate = Date()
            let timeInterval = currentDate.timeIntervalSince(self.startDate)
            let timerDate = Date(timeIntervalSince1970: timeInterval)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(0.0))
            
            let timeString = dateFormatter.string(from: timerDate)
            self.secondsLabel.text = timeString
        })
        
        var reginerateTimer = Timer()
        reginerateTimer = Timer.every(0.01) {
            if self.array.count > 1{
                self.randomWord()
            }
        }
        
        self.timerArray.append(self.boxTimer)
        self.timerArray.append(reginerateTimer)
        self.timeArray.append(self.stopwatchTimer!)
        
        self.setupGameTimers()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showBanner"), object: nil)

    }
    
    func stringFromTimeInterval(_ interval:TimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
        
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
    }
    
    func spawnNumbers(withDuration duration: TimeInterval) {
        let numberBox = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500), index: nil)
        numberBox.indexs = array[index]
        numberBox.zPosition = 0
        index += 1
        
        numberBox.physicsBody = SKPhysicsBody(rectangleOf: numberBox.texture!.size())
        numberBox.physicsBody?.categoryBitMask = Physics.Box
        numberBox.physicsBody?.contactTestBitMask = Physics.Ball
        numberBox.physicsBody?.collisionBitMask = Physics.Ball
        numberBox.physicsBody?.isDynamic = false
        numberBox.physicsBody?.affectedByGravity = false
        numberBox.name = "box"
        
        let randY = CGFloat(arc4random_uniform(UInt32(frame.size.height)))
        let randX = CGFloat(arc4random_uniform(UInt32(frame.size.width)))
        let randPos = arc4random() % 4
        
        switch randPos {
        case 0:
            numberBox.position.x = 0
            numberBox.position.y = randY
            addChild(numberBox)
            numberBox.scale()
            break;
            
        case 1:
            numberBox.position.x = randX
            numberBox.position.y = 0
            addChild(numberBox)
            numberBox.scale()
            break
            
        case 2:
            numberBox.position.x = randX
            numberBox.position.y = frame.size.height
            addChild(numberBox)
            numberBox.scale()
            break
            
        case 3:
            numberBox.position.x = frame.size.width
            numberBox.position.y = randY
            addChild(numberBox)
            numberBox.scale()
            break
        
        default:
            numberBox.position.x = 0
            numberBox.position.y = randY
            addChild(numberBox)
            numberBox.scale()
        }
        
        numberBox.run(SKAction.move(to: mainBall.position, duration: duration))
        checkBox(numberBox)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA.node!
        let secondBody = contact.bodyB.node!
        
        if firstBody.name  == "box" && secondBody.name == "bullet" {
            collisionBullet(withBox: firstBody as! NumberBox, andBullet: secondBody as! SKShapeNode)
        } else if firstBody.name == "bullet" && secondBody.name == "box" {
            collisionBullet(withBox: secondBody as! NumberBox, andBullet: firstBody as! SKShapeNode)
        } else if firstBody.name  == "ball" && secondBody.name == "box" {
            collisionMain(withBox: secondBody as! NumberBox)
        } else if firstBody.name  == "box" && secondBody.name == "ball" {
            collisionMain(withBox: firstBody as! NumberBox)
        }
    }
    
    func collisionMain(withBox box: NumberBox) {
        if box.currentState != .used {
            boxTimer.invalidate()
            gameOver()
            
            box.physicsBody?.isDynamic = true
            box.physicsBody?.affectedByGravity = true
            box.physicsBody?.mass = 5.0

            box.removeAllActions()
            box.used()
            
            box.physicsBody = nil
        }
    }
    
    func collisionBullet(withBox box: NumberBox, andBullet bullet: SKShapeNode) {
        if bullet.used.used == false && intersects(box){
            box.physicsBody?.isDynamic = true
            box.physicsBody?.affectedByGravity = true
            box.physicsBody?.mass = 5.0
            
            bullet.physicsBody?.mass = 5.0
            
            box.removeAllActions()
            bullet.removeAllActions()
            
            box.used()
            bullet.used.used = true
            
            point()
        }
    }
    
    func point() {
        numbersShot += 1
        setScore(numbersShot)
        shotNumberLabel.score = Int32(getScore())
    }
    
    override func prepareForGameOver() {
        for timer in timerArray {
            timer.invalidate()
        }
        
        stopwatchTimer!.invalidate()
        stopwatchTimer = nil
        
        hasGameStarted = false
        
        updateScore(numbersShot)
        
        setShareDetails("I just shot \(numbersShot) numbers playing shoot mode in a FREE game called Number Tap!  Download today! #numbertapgame", image: snapshot, url: URL(string: "http://apple.co/2bvrooQ")!)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "hideBanner"), object: nil)
    }
    
    override func resetScene() {
        for timer in timerArray {
            timer.invalidate()
        }
        
        stopwatchTimer = nil
        
        secondsLabel.text = "00:00:00"
        
        gameBegin()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if hasGameStarted == true {
                let bullet = SKShapeNode(circleOfRadius: 15)
                bullet.position = mainBall.position
                bullet.physicsBody = SKPhysicsBody(circleOfRadius: 15)
                bullet.physicsBody?.affectedByGravity = false
                bullet.fillColor = mainBall.fillColor
                bullet.strokeColor = mainBall.fillColor
                bullet.name = "bullet"
                
                bullet.physicsBody?.categoryBitMask = Physics.Bullet
                bullet.physicsBody?.collisionBitMask = Physics.Box
                bullet.physicsBody?.contactTestBitMask = Physics.Box
                bullet.physicsBody?.restitution = 1.0
                
                var dx = CGFloat(location.x - mainBall.position.x)
                var dy = CGFloat(location.y - mainBall.position.y)
                
                let magnitude = sqrt(dx * dx + dy * dy)
                
                dx /= magnitude
                dy /= magnitude
                
                let vector = CGVector(dx: 18.0 * dx, dy: 18.0 * dy)
                
                addChild(bullet)
                
                bullet.physicsBody?.applyImpulse(vector)

            }
            
            handleTouchedPoint(location)
        }
    }
    
    func distanceBetween(_ p1 : CGPoint, p2 : CGPoint) -> CGFloat {
        let dx : CGFloat = p1.x - p2.x
        let dy : CGFloat = p1.y - p2.y
        return sqrt(dx * dx + dy * dy)
    }
    
    func checkBox(_ box: NumberBox) {
        var _ = Timer()
        
        
        visibleBoxTimer = Timer.every(0.0001, {
            if self.intersects(box) && box.usedBox == false {
                self.visibleBoxesArray.append(box)
            }
        })
        
        _ = Timer.every(0.0001, {
            if self.distanceBetween(box.position, p2: self.mainBall.position) < 110 {
                box.removeAllActions()
                box.physicsBody?.isDynamic = true
                box.physicsBody?.restitution = 1.0
            }
        })
    }
    
    
    
}
