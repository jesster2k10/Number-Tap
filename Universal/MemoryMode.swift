//
//  MemoryMode.swift
//  Number Tap
//
//  Created by Jesse on 05/08/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit

class Memory: BaseScene {

    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(counterHasComplete), name: k.NotificationCenter.Counter, object: nil)

        randomWord()
        start(kGameMode.kMemory, cam: nil)
        showAlert()
    }
    
    func showAlert() {
        if keyAlreadyExist("hasPlayedMemory") != true {
            let alertVC = PMAlertController(title: "Welcome to Memory Mode!", description: "Hey! This is memory mode, you have 10 seconds to memorize each number! Every time you tap the correct you get another little sneak peek of the other numbers! Each round is endless! Just don't mess up..", image: nil, style: .AlertWithBlur)
            
            let letsGoAction = PMAlertAction(title: "Let's Go!", style: .Default) {
                print("Let's go!")
                self.startCountDown()
            }
            
            let cancelAction = PMAlertAction(title: "Nah...", style: .Cancel) {
                print("cancel")
                
                let gameModes = GameModes()
                self.view?.presentScene(gameModes, transition: SKTransition.crossFadeWithDuration(1))
            }
            
            alertVC.addAction(letsGoAction)
            alertVC.addAction(cancelAction)
            
            self.view?.window?.rootViewController!.presentViewController(alertVC, animated: true, completion: nil)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasPlayedMemory")
            
            print("Show Alert")
        } else {
            setup(kGameMode.kMemory, cam: nil)
        }
    }
    
    func counterHasComplete() {
        for node in countdownArray {
            node.runAction(SKAction.fadeOutWithDuration(1))
        }
        countdownTimer.invalidate()
        
        counterIsComplete()
    }
    
    func counterIsComplete() {
        setup(kGameMode.kMemory, cam: nil)
        NSTimer.after(10) { 
            for box in self.boxArray {
                box.flip()
            }
        }
    }
    
    func startGame() {
        
    }
    
    func keyAlreadyExist(kUsernameKey: String) -> Bool {
        return NSUserDefaults.standardUserDefaults().objectForKey(kUsernameKey) != nil
    }
}
