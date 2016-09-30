//
//  TutorialScene.swift
//  Number Tap
//
//  Created by jesse on 14/06/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit
import PermissionScope

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

class TutorialScene: InitScene {
    
    var title: SKNode!
    var backButton: SKLabelNode!
    var skipButton: SKLabelNode!
    var welcomeLabel: SKLabelNode!
    var descLineOne: SKLabelNode!
    var descLineTwo: SKLabelNode!
    var descLineThree: SKLabelNode!
    var tapNumberLabel: SKLabelNode!
    var numberLabel: SKLabelNode!
    var finger: SKLabelNode!
    
    var numberBox1: SKSpriteNode!
    var numberBox2: SKSpriteNode!
    var numberBox3: SKSpriteNode!
    var numberBox4: SKSpriteNode!
    
    var originalPosition: CGPoint!
    var boxArray: NSMutableArray!
    var mainCamera: SKCameraNode!
    var camNode: SKNode!
    
    var touch = 1
    var number = 2
    var tutorial = 1
    var isTapToContinue = false
    var userWonClock = false

    override func didMove(to view: SKView) {
        setupScene()
        setupCamera()
        setupText()
        setupBoxes()
        setupNodes()
        setupNumberLabel()
        setupFinger()
        setupActions()
    }
    
    func setupText() {
        backButton = SKLabelNode(fontNamed: k.Montserrat.UltraLight)
        backButton.text = "BACK"
        backButton.fontColor = SKColor.white
        backButton.fontSize = 55
        backButton.position = CGPoint(x: -299, y: 760)
        backButton.alpha = 0
        camera!.addChild(backButton)
        
        skipButton = SKLabelNode(fontNamed: k.Montserrat.UltraLight)
        skipButton.text = "SKIP"
        skipButton.fontColor = SKColor.white
        skipButton.fontSize = 55
        skipButton.position = CGPoint(x: 290, y: backButton.position.y)
        camera!.addChild(skipButton)
        
        welcomeLabel = SKLabelNode(fontNamed: k.Montserrat.Regular)
        welcomeLabel.text = "Welcome to Number Tap!"
        welcomeLabel.fontColor = SKColor.white
        welcomeLabel.fontSize = 65
        welcomeLabel.horizontalAlignmentMode = .center
        welcomeLabel.position = CGPoint(x: frame.midX, y: 1400)
        addChild(welcomeLabel)
        
        originalPosition = welcomeLabel.position
        welcomeLabel.position.y = originalPosition.y - 35
        
        descLineOne = SKLabelNode(fontNamed: "Montserrat-UltraLight")
        descLineOne.text = "Hey, this is Number Tap"
        descLineOne.fontSize = 50
        descLineOne.fontColor = SKColor.white
        descLineOne.horizontalAlignmentMode = .center
        descLineOne.position = CGPoint(x: frame.midX, y: 1300)
        addChild(descLineOne)
        
        descLineTwo = SKLabelNode(fontNamed: "Montserrat-UltraLight")
        descLineTwo.text = "It's pretty straight forward"
        descLineTwo.fontSize = 50
        descLineTwo.fontColor = SKColor.white
        descLineTwo.horizontalAlignmentMode = .center
        descLineTwo.position = CGPoint(x: descLineOne.position.x, y: descLineOne.position.y - 60)
        addChild(descLineTwo)
        
        descLineThree = SKLabelNode(fontNamed: "Montserrat-UltraLight")
        descLineThree.text = "Tap the number shown on the screen"
        descLineThree.fontSize = 50
        descLineThree.fontColor = SKColor.white
        descLineThree.horizontalAlignmentMode = .center
        descLineThree.position = CGPoint(x: descLineTwo.position.x, y: descLineTwo.position.y - 60)
        addChild(descLineThree)
        
    }
    
    func setupNumberLabel() {
        tapNumberLabel = SKLabelNode(fontNamed: k.Montserrat.SemiBold)
        tapNumberLabel.fontSize = 65
        tapNumberLabel.fontColor = SKColor.white
        tapNumberLabel.text = "Tap Number: "
        tapNumberLabel.horizontalAlignmentMode = .center
        tapNumberLabel.position = CGPoint(x: frame.midX - 20, y: numberBox4.position.y - 300)
        tapNumberLabel.alpha = 0
        addChild(tapNumberLabel)
        
        numberLabel = SKLabelNode(fontNamed: k.Montserrat.SemiBold)
        numberLabel.fontSize = 75
        numberLabel.text = String(number)
        numberLabel.fontColor = k.flatColors.red
        numberLabel.horizontalAlignmentMode = .center
        numberLabel.position = CGPoint(x: tapNumberLabel.position.x  + 270, y: tapNumberLabel.position.y)
        numberLabel.alpha = 0
        addChild(numberLabel)
    }
    
    func setupBoxes() {
        let firstPos = CGPoint(x: frame.midX - 300, y: descLineThree.position.y - 300)
        
        createBox(13, position: firstPos, zRotation: 13.406, name: "box1")
        createBox(33, position: CGPoint(x: firstPos.x + 195, y: firstPos.y), zRotation: -0.196, name: "box2")
        createBox(29, position: CGPoint(x: firstPos.x + 390, y: firstPos.y), zRotation: -5.982, name: "box3")
        createBox(2, position: CGPoint(x: firstPos.x + 585, y: firstPos.y), zRotation: 15.34, name: "box4")
    }
    
    func setupScene() {
        size = CGSize(width: 1536, height: 2048)
        scaleMode = .aspectFill
        backgroundColor = SKColor(red: 27/255, green: 27/255, blue: 27/255, alpha: 1)
        
        boxArray = NSMutableArray()
    }
    
    func setupFinger() {
        finger = SKLabelNode(text: "👆")
        finger.fontSize = 152
        finger.position = CGPoint(x: numberBox4.position.x, y: numberBox4.position.y - 180)
        finger.alpha = 0
        finger.zPosition = 1000
        addChild(finger)
    }
    
    func setupCamera() {
        camNode = SKNode()
        camNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(camNode)
        
        mainCamera = SKCameraNode()
        
        camera = mainCamera
        addChild(mainCamera)
        
        mainCamera.position = camNode.position
    }
    
    func setupNodes() {
        
        numberBox1 = self.childNode(withName: "box1") as! SKSpriteNode
        numberBox2 = self.childNode(withName: "box2") as! SKSpriteNode
        numberBox3 = self.childNode(withName: "box3") as! SKSpriteNode
        numberBox4 = self.childNode(withName: "box4") as! SKSpriteNode
    }
    
    func setupActions() {
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        let blinkAction = SKAction.sequence([fadeOutAction, fadeInAction])
        let blinkForeverAction = SKAction.repeatForever(blinkAction)
        let scaleAction = SKAction.scale(to: 2, duration: 1, delay: 1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2)
        let moveAction = SKAction.moveTo(y: originalPosition.y, duration: 1)
        let fadeInSec = SKAction.fadeIn(withDuration: 1)
        
        numberLabel.position.y = numberLabel.position.y - 20
        tapNumberLabel.position.y = tapNumberLabel.position.y - 20
        
        let moveNumberAction = SKAction.moveTo(y: numberLabel.position.y, duration: 1)
        let numberFallAndFade = SKAction.group([fadeInSec, moveNumberAction])
        
        let fallAndFade = SKAction.group([fadeInSec, moveAction])
        
        welcomeLabel.run(fallAndFade, completion: {
            self.descLineOne.run(fadeInSec , completion: {
                self.removeAllActions()
                
                self.descLineTwo.run(fadeInSec, completion: {
                    self.removeAllActions()
                    
                    self.descLineThree.run(fadeInSec, completion: {
                        self.removeAllActions()
                        
                        self.numberBox1.run(scaleAction, completion: {
                            self.removeAllActions()
                        })
                        
                        self.numberBox2.run(scaleAction, completion: {
                            self.removeAllActions()
                        })
                        
                        self.numberBox3.run(scaleAction, completion: {
                            self.removeAllActions()
                        })
                        
                        self.numberBox4.run(scaleAction, completion: {
                            self.removeAllActions()
                            
                            self.tapNumberLabel.run(numberFallAndFade)
                            self.numberLabel.run(numberFallAndFade)
                            
                            self.numberLabel.removeAllActions()
                            self.numberBox1.removeAllActions()
                            self.tapNumberLabel.removeAllActions()
                            
                            self.finger.run(fadeInSec, completion: { 
                                self.removeAllActions()
                                self.finger.run(blinkForeverAction)
                            })
                    })
                })
            })
         })
      })
    }
    
    func darkenBox(_ box: SKSpriteNode) {
        let scaleSequence = SKAction.sequence([SKAction.scale(to: 0.95, duration: 0.1), SKAction.scale(to: 1, duration: 0.1)])
        self.run(scaleSequence)
        let texture = SKTexture(imageNamed: "numberGreyedOut")
        box.texture = texture
    }
    
    func selected(_ box: SKSpriteNode, touch: Int) {
        print("Score")
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        let fadeInSec = SKAction.fadeIn(withDuration: 1)
        
        let blinkAction = SKAction.sequence([fadeOutAction, fadeInAction])
        let blinkForeverAction = SKAction.repeatForever(blinkAction)
        
        finger.run(fadeOutAction)
        finger.removeAllActions()
        
        darkenBox(box)
        
        if touch == 1 {
            let labelName = numberBox1.childNode(withName: "box1_label") as! SKLabelNode
            
            number = Int(labelName.text!)!
            finger.position = CGPoint(x: numberBox1.position.x, y: numberBox1.position.y - 180)
            finger.zPosition = 10000
            numberLabel.text = String(number)
            finger.run(fadeInSec, completion: {
                self.finger.removeAllActions()
                self.finger.run(blinkForeverAction)
            })
        } else if touch == 2 {
            let labelName = numberBox2.childNode(withName: "box2_label") as! SKLabelNode
            
            number = Int(labelName.text!)!
            finger.position = CGPoint(x: numberBox2.position.x, y: numberBox2.position.y - 180)
            finger.zPosition = 10000
            numberLabel.text = String(number)
            finger.run(fadeInSec, completion: {
                self.finger.removeAllActions()
                self.finger.run(blinkForeverAction)
            })
        } else if touch == 3 {
            let labelName = numberBox3.childNode(withName: "box3_label") as! SKLabelNode
            
            number = Int(labelName.text!)!
            finger.position = CGPoint(x: numberBox3.position.x, y: numberBox3.position.y - 180)
            finger.zPosition = 10000
            numberLabel.text = String(number)
            finger.run(fadeInSec, completion: {
                self.finger.removeAllActions()
                self.finger.run(blinkForeverAction)
            })
            
            
        }
        
        
    }
    
    func deselect(_ box: SKSpriteNode) {
        var normTexture : SKTexture? = SKTexture(imageNamed: "numberNormal")
        let block = SKAction.run { 
            box.texture = normTexture
        }
        
        box.run(block) { 
            box.removeAllActions()
            normTexture = nil
        }
    }
    
    func createBox(_ number: Int, position: CGPoint, zRotation: CGFloat, name: String = "box") {
        let box = SKSpriteNode(imageNamed: "numberNormal")
        box.zRotation = zRotation
        box.position = position
        box.name = name
        addChild(box)
        
        box.setScale(0)
        
        let label = SKLabelNode(fontNamed: k.Montserrat.SemiBold)
        label.text = String(number)
        label.fontSize = 32
        label.zPosition = 100000
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontColor = UIColor.white
        label.name = name + "_label"
        box.addChild(label)
        
        boxArray.add(box)
    }
    
    func showContinue(_ count: Int, text: String) {
        if count != 0 {
            
            let visualEffect = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: visualEffect)
            blurView.frame = view!.bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view!.addSubview(blurView)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            label.center = CGPoint(x: view!.bounds.midX, y: view!.bounds.midY + 25)
            label.textAlignment = NSTextAlignment.center
            label.text = text
            label.font = UIFont(name: k.Montserrat.Light, size: 32)
            label.textColor = UIColor.white
            label.alpha = 0
            self.view!.addSubview(label)
            
            UIView.animate(withDuration: 1, animations: {
                label.center = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY)
                label.alpha = 1
                }, completion: { (value: Bool) in
                    
                    let delayTime = DispatchTime.now() + Double(Int64(1.85 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        
                        if count != 4 {
                            let originalCameraPosition = self.mainCamera.position
                            let moveAction = SKAction.moveTo(x: originalCameraPosition.x + 1080, duration: 1)
                            self.mainCamera.run(moveAction)
                        }
                        
                        UIView.animate(withDuration: 1, animations: {
                            label.alpha = 0
                            label.center = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY - 25)
                            blurView.alpha = 0
                            
                            }, completion: { (value: Bool) in
                                label.removeFromSuperview()
                                blurView.removeFromSuperview()
                                
                                self.continueTutorial(count)
                        })
                    }
            })
        }

//        } else if count == 2 {
//            
//            let visualEffect = UIBlurEffect(style: .dark)
//            let blurView = UIVisualEffectView(effect: visualEffect)
//            blurView.frame = view!.bounds
//            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            self.view!.addSubview(blurView)
//            
//            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//            label.center = CGPoint(x: view!.bounds.midX, y: view!.bounds.midY + 25)
//            label.textAlignment = NSTextAlignment.center
//            label.text = "Try Again :("
//            label.font = UIFont(name: k.Montserrat.Light, size: 32)
//            label.textColor = UIColor.white
//            label.alpha = 0
//            self.view!.addSubview(label)
//            
//            UIView.animate(withDuration: 1, animations: {
//                label.center = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY)
//                label.alpha = 1
//                }, completion: { (value: Bool) in
//                    
//                    let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
//                    DispatchQueue.main.asyncAfter(deadline: delayTime) {
//                        
//                        UIView.animate(withDuration: 1, animations: {
//                            label.alpha = 0
//                            label.center = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY - 25)
//                            blurView.alpha = 0
//                            
//                            
//                            }, completion: { (value: Bool) in
//                                label.removeFromSuperview()
//                                blurView.removeFromSuperview()
//                                
//                                self.continueTutorial(1)
//                        })
//                    }
//            })
//
//        }
    }
    
    func continueTutorial(_ count: Int) {
        if count == 1 {
            tutorial = 2
            touch = 1
            finger.alpha = 0
            
            isTapToContinue = false
            
            for box in boxArray {
                if let box = box as? SKSpriteNode {
                    box.position = CGPoint(x: box.position.x + 1080, y: box.position.y)
                }
            }

            for child in children {
                child.alpha = 0
                backButton.alpha = 1
                skipButton.alpha = 2
            }
            
            welcomeLabel.text = "Let's add the clock"
            descLineOne.text = "You seem to get the hang of it now."
            descLineTwo.text = "It's about time we introduce the clock"
            descLineThree.text = "You've got 10 seconds on the clock. Beat it!"
            
            welcomeLabel.position = CGPoint(x: welcomeLabel.position.x + 1080, y: welcomeLabel.position.y)
            descLineOne.position = CGPoint(x: descLineOne.position.x + 1080, y: descLineOne.position.y)
            descLineTwo.position = CGPoint(x: descLineTwo.position.x + 1080, y: descLineTwo.position.y)
            descLineThree.position = CGPoint(x: descLineThree.position.x + 1080, y: descLineThree.position.y)
            numberLabel.position = CGPoint(x: numberLabel.position.x + 1080, y: numberLabel.position.y)
            tapNumberLabel.position = CGPoint(x: tapNumberLabel.position.x + 1080, y: tapNumberLabel.position.y)
            
            number = 2
            
            numberLabel.text = String(number)
            
            let original = welcomeLabel.position
            welcomeLabel.position = CGPoint(x: original.x, y: original.y - 25)
            
            let timerSpace = SKTexture(imageNamed: "timerSpace")
            let clock = ProgressNode()
            clock.position = CGPoint(x: welcomeLabel.position.x, y: welcomeLabel.position.y + 300)
            clock.zPosition = 1000
            clock.name = "clock"
            clock.alpha = 0
            clock.radius = timerSpace.size().width / 2
            clock.width = 8.0
            clock.color = UIColor(rgba: "#e74c3c")
            clock.backgroundColor = UIColor(rgba: "#434343")
            clock.setScale(2)
            addChild(clock)
            
            let tapToContinue = SKLabelNode(fontNamed: k.Montserrat.Light)
            tapToContinue.fontSize = 55
            tapToContinue.text = "Tap To Continue"
            tapToContinue.horizontalAlignmentMode = .center
            tapToContinue.position = CGPoint(x: descLineThree.position.x, y: descLineThree.position.y - 300)
            tapToContinue.name = "tap to continue"
            addChild(tapToContinue)
            
            for child in children {
                child.alpha = 0
            }
            
            let fadeInAction = SKAction.fadeIn(withDuration: 0.8)
            let fallAction = SKAction.moveTo(y: original.y, duration: 1)
            let fadeInSec = SKAction.fadeIn(withDuration: 1)
            let fallAndFade = SKAction.group([fadeInSec, fallAction])
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
            let fadeInActio = SKAction.fadeIn(withDuration: 0.5)
            let blinkAction = SKAction.sequence([fadeOutAction, fadeInActio])
            let blinkForeverAction = SKAction.repeatForever(blinkAction)
            
            clock.run(fadeInAction, completion: {
                self.welcomeLabel.run(fallAndFade, completion: {
                    self.descLineOne.run(fadeInSec, completion: {
                        self.removeAllActions()
                        
                        self.descLineTwo.run(fadeInSec, completion: {
                            self.removeAllActions()
                            
                            self.descLineThree.run(fadeInSec, completion: {
                                self.removeAllActions()
                                
                                tapToContinue.run(blinkForeverAction)
                                self.isTapToContinue = true
                                print("Tap to continue is true")
                            })
                        })
                    })
                })
            })

        } else if count == 2 {
            let tapToContinue = childNode(withName: "tap to continue") as! SKLabelNode
            let clock = childNode(withName: "clock") as! ProgressNode
            
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.25)
            tapToContinue.run(fadeOutAction)
            tapToContinue.removeAllActions()
            tapToContinue.removeFromParent()
            
            let fade = SKAction.fadeIn(withDuration: 0.25)
            
            tapNumberLabel.run(fade)
            numberLabel.run(fade)
            
            print("Array: \(self.boxArray)")
            
            for box in self.boxArray {
                if let box = box as? SKSpriteNode {
                    box.alpha = 0
                    
                    self.deselect(box)
                    self.touch = 1
                    
                    let fadeAction = SKAction.run({ 
                        box.alpha = 1
                        
                        clock.countdown(10, completionHandler: { (Void) in
                            clock.stopCountdown()
                            self.userWonClock = false
                            self.showContinue(1, text: "Try Again :(")
                        })
                    })
                    
                    box.run(fadeAction)
                }
            }

        }
        
        else if count == 3 {
            let clock = childNode(withName: "clock") as! ProgressNode
            clock.stopCountdown()
            
            for child in children {
                child.alpha = 0
            }
            
            welcomeLabel.position = CGPoint(x: welcomeLabel.position.x + 1080, y: welcomeLabel.position.y)
            descLineOne.position = CGPoint(x: descLineOne.position.x + 1080, y: descLineOne.position.y)
            descLineTwo.position = CGPoint(x: descLineTwo.position.x + 1080, y: descLineTwo.position.y)
            descLineThree.position = CGPoint(x: descLineThree.position.x + 1080, y: descLineThree.position.y)
            numberLabel.position = CGPoint(x: numberLabel.position.x + 1080, y: numberLabel.position.y)
            
            welcomeLabel.text = "Are you ready?"
            descLineOne.text = "That's about the basics of the game"
            descLineTwo.text = "It's time for us to advance."
            descLineThree.text = "But first there's some permissions I need."
            
            let original = welcomeLabel.position
            welcomeLabel.position = CGPoint(x: original.x, y: original.y - 25)
            
            let tapToContinue = SKLabelNode(fontNamed: k.Montserrat.Light)
            tapToContinue.fontSize = 55
            tapToContinue.text = "Tap To Continue"
            tapToContinue.horizontalAlignmentMode = .center
            tapToContinue.position = CGPoint(x: descLineThree.position.x, y: descLineThree.position.y - 300)
            tapToContinue.name = "tap to continue"
            tapToContinue.alpha = 0
            addChild(tapToContinue)
            
            let fallAction = SKAction.moveTo(y: original.y, duration: 1)
            let fadeInSec = SKAction.fadeIn(withDuration: 1)
            let fallAndFade = SKAction.group([fadeInSec, fallAction])
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
            let fadeInActio = SKAction.fadeIn(withDuration: 0.5)
            let blinkAction = SKAction.sequence([fadeOutAction, fadeInActio])
            let blinkForeverAction = SKAction.repeatForever(blinkAction)
            
            welcomeLabel.run(fallAndFade, completion: {
                self.descLineOne.run(fadeInSec, completion: {
                    self.removeAllActions()
                    
                    self.descLineTwo.run(fadeInSec, completion: {
                        self.removeAllActions()
                        
                        self.descLineThree.run(fadeInSec, completion: {
                            self.removeAllActions()
                            
                            tapToContinue.run(blinkForeverAction)
                            self.isTapToContinue = true
                            print("Tap to continue is true")
                        })
                    })
                })
            })
            
            tutorial = 3
        } else if count == 4 {
            let gs = GameScene()
            let transititon = SKTransition.crossFade(withDuration: 1)
            view?.presentScene(gs, transition: transititon)
        }
        
    }
    
    func touched(_ location: CGPoint) {
        for box in boxArray {
            if (box as! SKSpriteNode).contains(location) {
                if let box = box as? SKSpriteNode {
                    for boxLabel in box.children {
                        if let boxLabel = boxLabel as? SKLabelNode {
                            if number == Int(boxLabel.text!) {
                                if tutorial == 2 {
                                    if touch < 4 {
                                        selected(box, touch: touch)
                                        touch += 1
                                    } else {
                                        showContinue(3, text: "Awesome")
                                    }
                                } else {
                                    if touch < 4 {
                                        selected(box, touch: touch)
                                        touch += 1
                                    } else {
                                        showContinue(1, text: "Great!")
                                    }
                                }
                            } else {
                                //Shake
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showPermissions() {
        let pscope = PermissionScope()
        
        // Set up permissions
        pscope.addPermission(ContactsPermission(),
                             message: "We use this to find\r\nfriends and their high scores")
        pscope.addPermission(NotificationsPermission(notificationCategories: nil),
                             message: "We use this to send you\r\nupdates and rewards")
        pscope.addPermission(PhotosPermission(),
                             message: "We use this to save\r\nphotos and gameplay")
        
        // Show dialog with callbacks
        pscope.show({ finished, results in
            print("got results \(results)")
            self.showContinue(4, text: "Let's Go!")
            }, cancelled: { (results) -> Void in
                print("thing was cancelled")
                self.showContinue(4, text: "Let's Go!")
        })   
    }
    
    override func userInteractionBegan(_ location: CGPoint) {
        
        if isTapToContinue && tutorial != 3 {
            print("Tapped")
            isTapToContinue = false
            continueTutorial(2)
        } else if isTapToContinue && tutorial == 3 {
            print("Tapped")
            isTapToContinue = false
            showPermissions()
        }
        
        if skipButton.contains(location) {
            if tutorial == 1 {
                continueTutorial(1)
            } else if tutorial == 2 {
                continueTutorial(2)
            } else  if tutorial == 3 {
                showPermissions()
            }
        }
        
        touched(location)
    }
}
