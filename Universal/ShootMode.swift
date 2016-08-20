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

    var boxTimer = NSTimer()
    var scoreTimer = NSTimer()
    var gameTimer = NSTimer()
    var timeArray: [NSTimer] = [NSTimer]()
    var stopwatchTimer : NSTimer?
    var visibleBoxTimer = NSTimer()

    var hits = 3
    var index = 0
    var length = 3.0
    var numbersShot = 0
    var startDate : NSDate!
    
    var hasGameStarted = false
    var visibleBoxesArray = [NumberBox]()
    var snapshot = UIImage()
    
    //TODO: Configure sharing to take screenshot and work well.
    override func didMoveToView(view: SKView) {
        //TODO: Change it to save the boolean in NSUserDefaults
        if NSUserDefaults.keyAlreadyExists(kHasPlayedShoot) == false {
            showShootAlert()
        } else {
            startTheGame()
        }
    }
    
    func startTheGame() {
        physicsWorld.contactDelegate = self
        view!.showsPhysics = false
        size = CGSizeMake(640, 960)
        scaleMode = .AspectFill
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(counterIsComplete), name: k.NotificationCenter.Counter, object: nil)
        
        randomWord()
        
        mainBall.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        mainBall.fillColor = k.flatColors.red
        mainBall.strokeColor = UIColor.clearColor()
        mainBall.zPosition = 10.0
        mainBall.name = "ball"
        
        mainBall.physicsBody = SKPhysicsBody(circleOfRadius: 75)
        mainBall.physicsBody?.categoryBitMask = Physics.Ball
        mainBall.physicsBody?.contactTestBitMask = Physics.Box
        mainBall.physicsBody?.collisionBitMask = Physics.Box
        mainBall.physicsBody?.affectedByGravity = false
        mainBall.physicsBody?.dynamic = false
        addChild(mainBall)
        
        shotNumberLabel.score = Int32(numbersShot)
        shotNumberLabel.horizontalAlignmentMode = .Left
        shotNumberLabel.position = CGPointMake(90,890)
        shotNumberLabel.fontColor = k.flatColors.red
        shotNumberLabel.zPosition = 10.0
        addChild(shotNumberLabel)
        
        numbersShotLabel.text = NSLocalizedString("numbers-shot", comment: "Numbers Shot")
        numbersShotLabel.fontSize = shotNumberLabel.fontSize
        numbersShotLabel.fontColor = UIColor.whiteColor()
        numbersShotLabel.horizontalAlignmentMode = .Left
        numbersShotLabel.position = CGPointMake(shotNumberLabel.position.x + 20, shotNumberLabel.position.y)
        numbersShotLabel.zPosition = 10.0
        addChild(numbersShotLabel)
        
        secondsLabel.position = CGPointMake(shotNumberLabel.position.x - 10, shotNumberLabel.position.y - 40)
        secondsLabel.horizontalAlignmentMode = .Left
        secondsLabel.text = "00:00:00"
        secondsLabel.fontSize = 26
        secondsLabel.fontColor = UIColor.whiteColor()
        secondsLabel.zPosition = 10.0
        addChild(secondsLabel)
        
        startCountDown()
    }
    
    func showShootAlert() {
        let alert = PMAlertController(title: "Welcome to Shoot!", description: "Hey, this is Shoot Mode in Number Tap! Shoot all the numbers and keep the ball safe. Avoid allowing the numbers attack the ball as it can be fatal.. \r\n\r\nThe aim is to shoot as many numbers as you can in the shortest amount of time but luckily time is infinite.\r\n\r\nAre you ready?", image: nil, style: .AlertWithBlur)
        alert.addAction(PMAlertAction(title: "Let's Go!", style: .Default, action: { 
            self.startTheGame()
        }))
        
        alert.addAction(PMAlertAction(title: "Nah..", style: .Cancel, action: { 
            let gameModes = GameModes()
            let transition = SKTransition.crossFadeWithDuration(1)
            self.view?.presentScene(gameModes, transition: transition)
            self.removeAllActions()
            self.removeAllChildren()
            self.removeFromParent()
        }))
        
        let vc = self.view?.window?.rootViewController
        vc!.presentViewController(alert, animated: true, completion: nil)
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kHasPlayedShoot)
    }
    
    func setupGameTimers() {
        var five = NSTimer()
        five = NSTimer.every(0.001) {
            if self.numbersShot == 3 {
                print("5 Numbers Shot")
                self.changeTimer(2)
                five.invalidate()
            }
        }
        
        var eight = NSTimer()
        eight = NSTimer.every(0.001) {
            if self.numbersShot == 7 {
                print("8 Numbers Shot")
                self.changeTimer(1.5)
                eight.invalidate()
            }
        }
        
        var eleven = NSTimer()
        eleven = NSTimer.every(0.001) {
            if self.numbersShot == 11 {
                print("11 Numbers Shot")
                self.changeTimer(1.25)
                eleven.invalidate()
            }
        }
        
        var fifteen = NSTimer()
        fifteen = NSTimer.every(0.001) {
            if self.numbersShot == 15 {
                print("15 Numbers Shot")
                self.changeTimer(1)
                fifteen.invalidate()
            }
        }
        
        var seventeen = NSTimer()
        seventeen = NSTimer.every(0.001) {
            if self.numbersShot == 17 {
                print("17 Numbers Shot")
                self.changeTimer(0.9)
                seventeen.invalidate()
            }
        }
        
        var twentyone = NSTimer()
        twentyone = NSTimer.every(0.001) {
            if self.numbersShot == 21 {
                print("21 Numbers Shot")
                self.changeTimer(0.85)
                twentyone.invalidate()
            }
        }
        
        var thirty = NSTimer()
        thirty = NSTimer.every(0.001) {
            if self.numbersShot == 30 {
                print("30 Numbers Shot")
                self.changeTimer(0.8)
                thirty.invalidate()
            }
        }
        
        NSTimer.after(6, { 
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
    
    func changeTimer(time: Double) {
        boxTimer.invalidate()
        
        boxTimer = NSTimer.every(time, {
            self.spawnNumbers(withDuration: time)
        })
    }
    
    func counterIsComplete(aNotification: NSNotification) {
        countdown.runAction(SKAction.fadeAlphaTo(0, duration: 1), completion: {
            print("Removed")
            self.countdown.removeFromParent()
            self.childNodeWithName("bg")?.removeFromParent()
            
            self.gameBegin()
        })
        
    }
    
    func gameBegin() {
        if let box = self.childNodeWithName("box") as? NumberBox {
            box.removeFromParent()
        }
        
        for box in visibleBoxesArray {
            box.removeFromParent()
        }
        
        self.hasGameStarted = true
        
        self.boxTimer = NSTimer.every(self.length, {
            self.spawnNumbers(withDuration: 3.0)
        })
        
        startDate = NSDate()
        stopwatchTimer = NSTimer.every(1.0/1.0, {
            let currentDate = NSDate()
            let timeInterval = currentDate.timeIntervalSinceDate(self.startDate)
            let timerDate = NSDate(timeIntervalSince1970: timeInterval)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: Int(0.0))
            
            let timeString = dateFormatter.stringFromDate(timerDate)
            self.secondsLabel.text = timeString
        })
        
        var reginerateTimer = NSTimer()
        reginerateTimer = NSTimer.every(0.01) {
            if self.array.count > 1{
                self.randomWord()
            }
        }
        
        self.timerArray.append(self.boxTimer)
        self.timerArray.append(reginerateTimer)
        self.timeArray.append(self.stopwatchTimer!)
        
        self.setupGameTimers()
        
        NSNotificationCenter.defaultCenter().postNotificationName("showBanner", object: nil)

    }
    
    func stringFromTimeInterval(interval:NSTimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
        
        let ms = Int((interval % 1) * 1000)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
    }
    
    func spawnNumbers(withDuration duration: NSTimeInterval) {
        let numberBox = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
        numberBox.indexs = array[index]
        numberBox.zPosition = 0
        index += 1
        
        numberBox.physicsBody = SKPhysicsBody(rectangleOfSize: numberBox.texture!.size())
        numberBox.physicsBody?.categoryBitMask = Physics.Box
        numberBox.physicsBody?.contactTestBitMask = Physics.Ball
        numberBox.physicsBody?.collisionBitMask = Physics.Ball
        numberBox.physicsBody?.dynamic = false
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
        
        numberBox.runAction(SKAction.moveTo(mainBall.position, duration: duration))
        checkBox(numberBox)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
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
            
            box.physicsBody?.dynamic = true
            box.physicsBody?.affectedByGravity = true
            box.physicsBody?.mass = 5.0

            box.removeAllActions()
            box.used()
            
            box.physicsBody = nil
        }
    }
    
    func collisionBullet(withBox box: NumberBox, andBullet bullet: SKShapeNode) {
        if bullet.used.used == false && intersectsNode(box){
            box.physicsBody?.dynamic = true
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
        
        setShareDetails("I just shot \(numbersShot) numbers playing shoot mode in a FREE game called Number Tap!  Download today! #numbertapgame", image: snapshot, url: NSURL(string: "http://apple.co/2bvrooQ")!)
        
        NSNotificationCenter.defaultCenter().postNotificationName("hideBanner", object: nil)
    }
    
    override func resetScene() {
        for timer in timerArray {
            timer.invalidate()
        }
        
        stopwatchTimer = nil
        
        secondsLabel.text = "00:00:00"
        
        gameBegin()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
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
    
    func distanceBetween(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
        let dx : CGFloat = p1.x - p2.x
        let dy : CGFloat = p1.y - p2.y
        return sqrt(dx * dx + dy * dy)
    }
    
    func checkBox(box: NumberBox) {
        var _ = NSTimer()
        
        
        visibleBoxTimer = NSTimer.every(0.0001, {
            if self.intersectsNode(box) && box.usedBox == false {
                self.visibleBoxesArray.append(box)
            }
        })
        
        _ = NSTimer.every(0.0001, {
            if self.distanceBetween(box.position, p2: self.mainBall.position) < 110 {
                box.removeAllActions()
                box.physicsBody?.dynamic = true
                box.physicsBody?.restitution = 1.0
            }
        })
    }
    
    
    
}
