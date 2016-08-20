//
//  FallingMode.swift
//  Number Tap
//
//  Created by jesse on 02/07/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import Foundation
import SpriteKit

class FallingMode: SKScene {
    var avaliableBoxes = [NumberBox]()
    var unavaliableBoxes = [NumberBox]()
    var avaliableNumbers = [Int]()
    var unavaliableNumbers = [Int]()
    //var array = [Int]()
    
    var indexs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
    
    var numbersTapped : Int = 0
    var number : Int = 0
    var index : Int = 0
    
    var lastSpawnTimeInterval : Double = 0.0
    var lastUpdateTimeInterval : Double = 0.0
    
    let starVideo = SKSpriteNode(imageNamed: "starVideo")
    let records = SKSpriteNode(imageNamed: "records")
    var scoreLabel = AnimatedScoreLabel(text: "", score: 0, size: 25, color: k.flatColors.red)
    var numbersTap = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    var tapOnLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let numberLabel = SKLabelNode(fontNamed: "Montserrat-SemiBold")
    let circularTimer = ProgressNode()
                                
    override func didMoveToView(view: SKView) {
        FTLogging().FTLog("Falling scene initiated")
        
        size = CGSizeMake(640, 960)
        backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        scaleMode = .AspectFill
        
        setup()
    }
    
    func setup() {
        let timerSpace = SKTexture(imageNamed: "timerSpace")
        circularTimer.position = CGPointMake(470, 850)
        circularTimer.radius = timerSpace.size().width / 2
        circularTimer.width = 8.0
        circularTimer.zPosition = 2
        circularTimer.color = UIColor(rgba: "#e74c3c")
        circularTimer.backgroundColor = UIColor(rgba: "#434343")
        addChild(circularTimer)
        
        scoreLabel.position = CGPointMake(circularTimer.position.x - 320, circularTimer.position.y)
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.fontColor = UIColor(rgba: "#e74c3c")
        addChild(scoreLabel)
        
        numbersTap.text = "NUMBERS TAPPED"
        numbersTap.position = CGPointMake(scoreLabel.position.x + 15, scoreLabel.position.y)
        numbersTap.horizontalAlignmentMode = .Left
        numbersTap.fontColor = UIColor.whiteColor()
        numbersTap.fontSize = 25
        numbersTap.zPosition = scoreLabel.zPosition
        addChild(numbersTap)
        
        starVideo.position = CGPointMake(scoreLabel.position.x + 10, scoreLabel.position.y - 32)
        starVideo.name = "starVideo"
        starVideo.zPosition = 2
        addChild(starVideo)
        
        records.position = CGPointMake(starVideo.position.x + 65, starVideo.position.y)
        records.name = "records"
        records.zPosition = 2
        addChild(records)
        
        self.tapOnLabel.fontColor = UIColor.whiteColor()
        self.tapOnLabel.fontSize = 30
        self.tapOnLabel.text = "TAP NUMBER:"
        self.tapOnLabel.horizontalAlignmentMode = .Center
        self.tapOnLabel.verticalAlignmentMode = .Center
        self.tapOnLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 25, -90)
        self.addChild(self.tapOnLabel)
        
        self.number = self.randomNumber()
        
        self.numberLabel.fontColor = UIColor(rgba: "#e74c3c")
        self.numberLabel.fontSize = 38
        self.numberLabel.text = String(self.number)
        self.numberLabel.horizontalAlignmentMode = .Center
        self.numberLabel.verticalAlignmentMode = .Center
        self.numberLabel.position = CGPointMake(self.tapOnLabel.position.x + 130, -90)
        self.addChild(self.numberLabel)
        
        self.tapOnLabel.runAction(SKAction.moveToY(90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0))
        self.numberLabel.runAction(SKAction.moveToY(90, duration: 1, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0), completion: {
        })
        
        randomWord()
    }
    
    
    func addNumber(indexOne: Int, indexTwo: Int, indexThree: Int, indexFour: Int) {
        let numberBox1 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
        let numberBox2 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
        let numberBox3 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
        let numberBox4 = NumberBox(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(400, 500), index: nil)
        
        numberBox1.indexs = indexOne
        numberBox1.zPosition = 222
        numberBox1.position = CGPointMake(170, circularTimer.position.y - 120)
        addChild(numberBox1)
        
        numberBox2.indexs = indexTwo
        numberBox2.zPosition = 222
        numberBox2.position = CGPointMake(270, circularTimer.position.y - 120)
        addChild(numberBox2)
        
        numberBox3.indexs = indexThree
        numberBox3.zPosition = 222
        numberBox3.position = CGPointMake(370, circularTimer.position.y - 120)
        addChild(numberBox3)
        
        numberBox4.indexs = indexFour
        numberBox4.zPosition = 222
        numberBox4.position = CGPointMake(470, circularTimer.position.y - 120)
        addChild(numberBox4)
        
        avaliableBoxes.append(numberBox1)
        avaliableBoxes.append(numberBox2)
        avaliableBoxes.append(numberBox3)
        avaliableBoxes.append(numberBox4)
        
        for box in avaliableBoxes {
            box.scale()
        }
        
        let minDuration = 2.0
        let maxDuration = 10.0
        let rangeDuration = maxDuration - minDuration
        _ = arc4random() % UInt32(rangeDuration + minDuration)
        
        let actionMove = SKAction.moveToY(tapOnLabel.position.y + 100, duration: maxDuration)
        
        numberBox1.runAction(actionMove, completion: {
            numberBox1.reScale(withCompletion: {
                numberBox1.removeAllActions()
                numberBox1.removeFromParent()
                self.avaliableBoxes.removeObject(numberBox1)
                self.unavaliableBoxes.append(numberBox1)
                self.avaliableNumbers.removeObject(indexOne)
            })
        })
        
        numberBox2.runAction(actionMove, completion: {
            numberBox2.reScale(withCompletion: {
                numberBox2.removeAllActions()
                numberBox2.removeFromParent()
                self.avaliableBoxes.removeObject(numberBox2)
                self.unavaliableBoxes.append(numberBox2)
                self.avaliableNumbers.removeObject(indexTwo)
            })
        })
        
        numberBox3.runAction(actionMove, completion: {
            numberBox3.reScale(withCompletion: {
                numberBox3.removeAllActions()
                numberBox3.removeFromParent()
                self.avaliableBoxes.removeObject(numberBox3)
                self.unavaliableBoxes.append(numberBox3)
                self.avaliableNumbers.removeObject(indexThree)
            })
        })
        
        numberBox4.runAction(actionMove, completion: {
            numberBox4.reScale(withCompletion: {
                numberBox4.removeAllActions()
                numberBox4.removeFromParent()
                self.avaliableBoxes.removeObject(numberBox4)
                self.unavaliableBoxes.append(numberBox4)
                self.avaliableNumbers.removeObject(indexFour)
            })
        })
        
    }
    
    //Game Logic
    func randomWord() {
        
        let getRandom = randomSequenceGenerator(1, max: 99)
        for _ in 1...99 {
            avaliableNumbers.append(getRandom());
            
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
        
        if avaliableNumbers.count > 0 {
            
            var randNum = 0
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(avaliableNumbers.count)))
            
            // your random number
            randNum = avaliableNumbers[arrayKey]
            
            // make sure the number isnt repeated
            avaliableNumbers.removeAtIndex(arrayKey)
            
            return randNum;
            
        } else {
            resetScene()
            
            
            var randNum = 0
            // random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(avaliableNumbers.count)))
            
            // your random number
            randNum = avaliableNumbers[arrayKey]
            
            // make sure the number isnt repeated
            avaliableNumbers.removeAtIndex(arrayKey)
            
            return randNum;
            
        }
        
    }
    
    func resetScene() {
        
        //shortestTimer.invalidate()
        //GameKitHelper.sharedGameKitHelper.reportLeaderboardIdentifier(k.GameCenter.Leaderboard.ShortestTimes, score: shortestTimeCounter)
        
        avaliableNumbers.removeAll()
        randomWord()
        
        //hasRun = 0
        
        /*numberBox1.indexs = array[0]
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
        numberBox24.indexs = array[23]*/
        
        
        number = randomNumber()
        numberLabel.text = "\(number)"
        
    }

    
    func loose() {
        
        //gameEnd(false)
    }
    
    func point() {
        
        number = randomNumber()
        numberLabel.text = String(number)
        
        //timeLabel.removeAllActions()
        
        _ = arc4random_uniform(250)+50
        
        //score += Int(randScore)
        numbersTapped += 1
        scoreLabel.score = Int32(numbersTapped)
        
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            for box in avaliableBoxes {
                if box.containsPoint(location) {
                    if box.containsPoint(location) {
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
        }
    }
    
    func playSound(fileName sound: String, onSprite node: SKNode?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let isSoundEnabled = defaults.boolForKey("isSoundEnabled")
        
        let soundAction = SKAction.playSoundFileNamed(sound, waitForCompletion: false)
        
        if isSoundEnabled {
            node!.runAction(soundAction, completion: {
                FTLogging().FTLog("\n Played sound with file named \r\n \(sound) \n")
            })
        } else {
            FTLogging().FTLog("\n Sound is disabled \n")
        }
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLast: CFTimeInterval) {
        
        lastSpawnTimeInterval += timeSinceLast
        if lastSpawnTimeInterval > 1 {
            
            if index < 18 {
                lastSpawnTimeInterval = 0
                
                let index1 = Int(arc4random_uniform(UInt32(avaliableNumbers.count)))
                avaliableNumbers.removeAtIndex(index1)
                
                let index2 = Int(arc4random_uniform(UInt32(avaliableNumbers.count)))
                avaliableNumbers.removeAtIndex(index2)
                
                let index3 = Int(arc4random_uniform(UInt32(avaliableNumbers.count)))
                avaliableNumbers.removeAtIndex(index3)
                
                let index4 = Int(arc4random_uniform(UInt32(avaliableNumbers.count)))
                avaliableNumbers.removeAtIndex(index4)
                
                addNumber(index1, indexTwo: index2, indexThree: index3, indexFour: index4)
                index += 1
                
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        var timeSinceLast : CFTimeInterval = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        if timeSinceLast > 1 {
            timeSinceLast = 1.0 / 60.0
            lastUpdateTimeInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLast)
    }

}