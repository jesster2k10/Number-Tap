//
//  ShuffleMode.swift
//  Number Tap Universal
//
//  Created by Jesse on 15/10/2016.
//  Copyright © 2016 Flatbox Studio. All rights reserved.
//

import SpriteKit

let k_SHUFFLE_COUNTDOWN_TIME = 60

class ShuffleMode: BaseScene {
    var positionArray: [CGPoint] = []
    var unTouchedPositionArray : [CGPoint] = []
    
    override func didMove(to view: SKView) {
        randomWord()
        start(.kShuffle, cam: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(counterIsComplete), name: NSNotification.Name(rawValue: k.NotificationCenter.Counter), object: nil)
        
        for box in boxArray {
            positionArray.append(box.position)
            unTouchedPositionArray.append(box.position)
        }
        
        startCountDown()
    }
    
    func counterIsComplete(_ aNotification: Notification) {
        countdown.run(SKAction.fadeAlpha(to: 0, duration: 1), completion: {
            print("Removed")
            self.countdown.removeFromParent()
            self.childNode(withName: "bg")?.removeFromParent()
            
            self.beginNewGame()
        })
    }
    
    func beginNewGame() {
        circularTimer.countdown(TimeInterval(k_SHUFFLE_COUNTDOWN_TIME)) { (Void) in
            self.gameOver()
        }
    }
    
    func shuffleBoxes() {
        for box in boxArray {
            let shuffleAction = SKAction.move(to: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), duration: 0.25, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.2)
            let designatedPoint = randomPosition(fromArray: &positionArray)
            let reOpenAction = SKAction.move(to: designatedPoint, duration: 0.25, delay: 0.5, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.2)
            let completeAction = SKAction.sequence([shuffleAction, reOpenAction])
            
            box.run(completeAction)
        }
    }
    
    func randomPosition(fromArray arr: inout [CGPoint]) -> CGPoint {
        if arr.count > 0 {
            var randPoint = CGPoint()
            let arrayKey = Int(arc4random_uniform(UInt32(arr.count)))
            randPoint = arr[arrayKey]
            arr.remove(at: arrayKey)
            
            return randPoint;
            
        } else {
            for point in unTouchedPositionArray {
                if !positionArray.contains(point) {
                    positionArray.append(point)
                }
            }
            //resetScene()
            
            var randPoint = CGPoint()
            let arrayKey = Int(arc4random_uniform(UInt32(arr.count)))
            randPoint = arr[arrayKey]
            arr.remove(at: arrayKey)
            
            return randPoint;
        }
        
    }
    
    func point() {
        
        number = randomNumber()
        numberLabel.text = String(number)
        
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
        
        shuffleBoxes()
    }

    
    override func userInteractionBegan(_ location: CGPoint) {
        handleTouchedPoint(location)
        
        for box in boxArray {
            if box.contains(location) {
                box.darken()
                
                if box.indexs == number {
                    box.used()
                    point()
                } else {
                    gameOver()
                }
            }
        }
    }
    
    override func toSceneReset() {
        positionArray = unTouchedPositionArray
        
        for point in unTouchedPositionArray {
            if !positionArray.contains(point) {
                positionArray.append(point)
            }
        }
        
        circularTimer.stopCountdown()
        circularTimer.countdown(TimeInterval(k_SHUFFLE_COUNTDOWN_TIME)) { (Void) in
            self.gameOver()
        }
    }
    
    override func userInteractionEnded(_ location: CGPoint) {
        for box in boxArray {
            if box.currentState != .used {
                box.normal()
            }
        }
    }

}
