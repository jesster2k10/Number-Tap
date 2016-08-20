//
//  TutorialScene.swift
//  Number Tap
//
//  Created by jesse on 14/06/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

class TutorialScene: InitScene {
    var title: SKNode!
    var welcomeLabel: SKLabelNode!
    var descLineOne: SKLabelNode!
    var descLineTwo: SKLabelNode!
    var descLineThree: SKLabelNode!
    var tapNumberLabel: SKLabelNode!
    var numberLabel: SKLabelNode!
    var finger: SKNode!
    
    var numberBox1: SKSpriteNode!
    var numberBox2: SKSpriteNode!
    var numberBox3: SKSpriteNode!
    var numberBox4: SKSpriteNode!
    
    var originalPosition: CGPoint!
    var boxArray: NSMutableArray!
    var mainCamera: SKCameraNode!
    
    var touch = 1

    override func didMoveToView(view: SKView) {
        setupCamera()
        setupNodes()
        setupActions()
    }
    
    func setupCamera() {
        mainCamera = self.childNodeWithName("Main Camera") as! SKCameraNode
    }
    
    func setupNodes() {
        title = self.childNodeWithName("title")
        welcomeLabel = title.childNodeWithName("Welcome Label") as! SKLabelNode
        
        descLineOne = self.childNodeWithName("Desc Line 1") as! SKLabelNode
        descLineTwo = self.childNodeWithName("Desc Line 2") as! SKLabelNode
        descLineThree = self.childNodeWithName("Desc Line 3") as! SKLabelNode
        
        tapNumberLabel = self.childNodeWithName("Tap number") as! SKLabelNode
        numberLabel = self.childNodeWithName("Number") as! SKLabelNode
        
        numberBox1 = self.childNodeWithName("Number Box 1") as! SKSpriteNode
        numberBox2 = self.childNodeWithName("Number Box 2") as! SKSpriteNode
        numberBox3 = self.childNodeWithName("Number Box 3") as! SKSpriteNode
        numberBox4 = self.childNodeWithName("Number Box 4") as! SKSpriteNode
        
        numberBox1.setScale(0)
        numberBox2.setScale(0)
        numberBox3.setScale(0)
        numberBox4.setScale(0)
        
        boxArray = NSMutableArray(array: [numberBox1, numberBox2, numberBox3, numberBox4])
        for box in boxArray {
            if let box = box as? SKSpriteNode {
                for child in box.children {
                    child.zPosition = 500
                }
            }
        }
        
        descLineOne.alpha = 0
        descLineTwo.alpha = 0
        descLineThree.alpha = 0

        finger = self.childNodeWithName("finger")
        finger.alpha = 0
        finger.zPosition = 111
        
        originalPosition = numberLabel.position
        
        numberLabel.alpha = 0
        numberLabel.position.y = originalPosition.y + 25
        
        tapNumberLabel.position.y = originalPosition.y + 25
        tapNumberLabel.alpha = 0
    }
    
    func setupActions() {
        let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
        let fadeInAction = SKAction.fadeInWithDuration(0.5)
        let blinkAction = SKAction.sequence([fadeOutAction, fadeInAction])
        let blinkForeverAction = SKAction.repeatActionForever(blinkAction)
        let scaleAction = SKAction.scaleTo(1, duration: 1, delay: 1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2)
        let moveAction = SKAction.moveToY(originalPosition.y, duration: 1)
        let fadeInSec = SKAction.fadeInWithDuration(1)
        let fallAndFade = SKAction.group([fadeInSec, moveAction])
        
        descLineOne.runAction(fadeInSec) {
            self.descLineOne.removeAllActions()
            
            self.descLineTwo.runAction(fadeInSec, completion: {
                self.descLineTwo.removeAllActions()
                
                self.descLineThree.runAction(fadeInSec, completion: {
                    self.descLineThree.removeAllActions()
                    
                    self.numberBox1.runAction(scaleAction, completion: {
                        self.numberBox1.removeAllActions()
                    })
                        
                    self.numberBox2.runAction(scaleAction, completion: {
                        self.numberBox2.removeAllActions()
                    })
                            
                    self.numberBox3.runAction(scaleAction, completion: {
                        self.numberBox3.removeAllActions()
                    })
                                
                    self.numberBox4.runAction(scaleAction, completion: {
                        self.numberBox4.removeAllActions()
                        self.tapNumberLabel.runAction(fallAndFade)
                                    
                        self.numberLabel.runAction(fallAndFade, completion: {
                            self.numberBox1.removeAllActions()
                            self.tapNumberLabel.removeAllActions()
                            
                            self.numberLabel.runAction(fadeInSec, completion: {
                                self.finger.runAction(blinkForeverAction)
                                
                            })
                        })
                    })
                })
            })
        }
    }
    
    func darkenBox(box: SKSpriteNode) {
        let scaleSequence = SKAction.sequence([SKAction.scaleTo(0.95, duration: 0.1), SKAction.scaleTo(1, duration: 0.1)])
        self.runAction(scaleSequence)
        let texture = SKTexture(imageNamed: "numberGreyedOut")
        box.texture = texture
    }
    
    func selected(box: SKSpriteNode, touch: Int) {
        print("Score")
        let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
        let fadeInAction = SKAction.fadeInWithDuration(0.5)
        let fadeInSec = SKAction.fadeInWithDuration(1)
        
        let blinkAction = SKAction.sequence([fadeOutAction, fadeInAction])
        let blinkForeverAction = SKAction.repeatActionForever(blinkAction)
        
        finger.runAction(fadeOutAction)
        finger.removeAllActions()
        
        darkenBox(box)
        
        if touch == 1 {
            let labelName = numberBox1.childNodeWithName("Number Box 1 Label") as! SKLabelNode
            
            finger.position = CGPointMake(numberBox1.position.x, numberBox1.position.y - 50)
            finger.zPosition = 10000
            numberLabel.text = labelName.text!
            finger.runAction(fadeInSec, completion: {
                self.finger.removeAllActions()
                self.finger.runAction(blinkForeverAction)
            })
        } else if touch == 2 {
            let labelName = numberBox2.childNodeWithName("Number Box 2 Label") as! SKLabelNode
            
            finger.position = CGPointMake(numberBox2.position.x, numberBox2.position.y - 50)
            finger.zPosition = 10000
            numberLabel.text = labelName.text!
            finger.runAction(fadeInSec, completion: {
                self.finger.removeAllActions()
                self.finger.runAction(blinkForeverAction)
            })
        } else if touch == 3 {
            let labelName = numberBox3.childNodeWithName("Number Box 3 Label") as! SKLabelNode
            
            finger.position = CGPointMake(numberBox3.position.x, numberBox3.position.y - 50)
            finger.zPosition = 10000
            numberLabel.text = labelName.text!
            finger.runAction(fadeInSec, completion: {
                self.finger.removeAllActions()
                self.finger.runAction(blinkForeverAction)
            })
        }
        
        
    }
    
    func showContinue(count: Int) {
        
        let visualEffect = UIBlurEffect(style: .Dark)
        let blurView = UIVisualEffectView(effect: visualEffect)
        blurView.frame = view!.bounds
        blurView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.view!.addSubview(blurView)
        
        let label = UILabel(frame: CGRectMake(0, 0, 200, 200))
        label.center = CGPointMake(CGRectGetMidX(view!.bounds), CGRectGetMidY(view!.bounds) + 25)
        label.textAlignment = NSTextAlignment.Center
        label.text = "Great!"
        label.font = UIFont(name: k.Montserrat.Light, size: 32)
        label.textColor = UIColor.whiteColor()
        label.alpha = 0
        self.view!.addSubview(label)
        
        UIView.animateWithDuration(1, animations: {
            label.center = CGPointMake(CGRectGetMidX(self.view!.bounds), CGRectGetMidY(self.view!.bounds))
            label.alpha = 1
            }, completion: { (value: Bool) in
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    
                    UIView.animateWithDuration(1, animations: {
                        label.alpha = 0
                        label.center = CGPointMake(CGRectGetMidX(self.view!.bounds), CGRectGetMidY(self.view!.bounds) - 25)
                        blurView.alpha = 0
                        
                        }, completion: { (value: Bool) in
                            label.removeFromSuperview()
                            blurView.removeFromSuperview()
                            
                            self.continueTutorial(count)
                    })
               }
        })
    }
    
    func continueTutorial(count: Int) {
        let moveAction = SKAction.moveToX(1080, duration: 1)
        mainCamera.runAction(moveAction)
        
        let page2 = self.childNodeWithName("Page2")
        let descL1 = page2?.childNodeWithName("Desc Line 1") as! SKLabelNode
        let descL2 = page2?.childNodeWithName("Desc Line 2") as! SKLabelNode
        let descL3 = page2?.childNodeWithName("Desc Line 3") as! SKLabelNode
        let title = page2?.childNodeWithName("title") as! SKLabelNode
        let tapToContinue = page2?.childNodeWithName("Tap to Continue") as! SKLabelNode
        
        let numberBox1 = page2?.childNodeWithName("Number Box 1") as! SKSpriteNode
        let numberBox2 = page2?.childNodeWithName("Number Box 2") as! SKSpriteNode
        let numberBox3 = page2?.childNodeWithName("Number Box 3") as! SKSpriteNode
        let numberBox4 = page2?.childNodeWithName("Number Box 4") as! SKSpriteNode
        
        boxArray.removeAllObjects()
        boxArray = NSMutableArray(array: [numberBox1, numberBox2, numberBox3, numberBox4])
        
        var original = title.position
        title.position = CGPointMake(original.x, original.y - 25)
        
        let clock = ProgressNode(radius: 5, color: k.flatColors.red, backgroundColor: SKColorWithRGBA(27/255, g: 27/255, b: 27/255, a: 1), width: 34, progress: 0)
        clock.position = CGPointMake(0, 343)
        clock.zPosition = 1000
        clock.name = "clock"
        clock.alpha = 0
        page2!.addChild(clock)
        
        
        let fadeInAction = SKAction.fadeInWithDuration(0.8)
        let fallAction = SKAction.moveToY(original.y, duration: 1)
        let fadeInSec = SKAction.fadeInWithDuration(1)
        let fallAndFade = SKAction.group([fadeInSec, fallAction])
        let fadeOutAction = SKAction.fadeOutWithDuration(0.5)
        let fadeInActio = SKAction.fadeInWithDuration(0.5)
        let blinkAction = SKAction.sequence([fadeOutAction, fadeInActio])
        let blinkForeverAction = SKAction.repeatActionForever(blinkAction)
        
        clock.runAction(fadeInAction, completion: {
            title.runAction(fallAndFade, completion: {
                descL1.runAction(fadeInSec, completion: { 
                    descL1.removeAllActions()
                    
                    descL2.runAction(fadeInSec, completion: {
                        descL2.removeAllActions()
                        
                        descL3.runAction(fadeInSec, completion: {
                            descL3.removeAllActions()
                            
                            tapToContinue.runAction(blinkForeverAction, completion: { 
                                
                            })
                        })
                    })
                })
            })
        })
    }
    
    override func userInteractionBegan(location: CGPoint) {
        for box in boxArray {
            if box.containsPoint(location) {
                if let box = box as? SKSpriteNode {
                    for boxLabel in box.children {
                        if let boxLabel = boxLabel as? SKLabelNode {
                            let number = Int(boxLabel.text!)
                            if number == Int(numberLabel.text!) {
                                if touch < 4 {
                                    selected(box, touch: touch)
                                    touch += 1
                                } else {
                                    showContinue(1)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}