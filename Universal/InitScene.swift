//
//  DefaultScene.swift
//  Universal Game Template
//
//  Created by Matthew Fecher on 12/4/15.
//  Copyright © 2015 Denver Swift Heads. All rights reserved.
//

import SpriteKit

class InitScene: SKScene {
    var isGamePaused: Bool! = false
    
    #if os(iOS)
    var counterLabel = UILabel()
    var pauseLabel = UILabel()
    var pausedTimer = Timer()
    var ablurView = UIVisualEffectView()
    #endif
    
    // ****************************************************
    // MARK: - Universal User Interaction
    // ****************************************************
    
    // These top-level methods are enhanced by extensions
    // See the "Interaction Extensions" group.
    
    // iOS | tvOS | OS/X have different user interactions.
    // By abstracting out, it opens the door to easily add
    // interactions and platforms (e.g. such as OS/X mouse/keyboard)
    
    #if os(iOS)
    func setUpListners() {
        //NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
       //NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
       //NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func appWillResignActive() {
        if !isGamePaused {
            self.pauseGame()
        }
    }
    
    func appDidEnterBackground() {
        if !isGamePaused {
            GameViewController().pauseMusic()
            self.pauseGame()
        }
    }
    
    func appWillEnterForeground() {
        self.unPauseGame {
            self.view?.isPaused = false
            
            if !self.isGamePaused {
                self.view?.isPaused = true
            }
        }
    }
    
    func pauseGame() {
        print("pause")
    }
    
    func unPauseGame(completionOfAnimation: @escaping () -> ()) {
        print("Un Pause")
    }
    
    func animate(completionOfAnimation: @escaping () -> ()) {
        print("Animating")
    }
    #endif
    
    func userInteractionBegan(_ location: CGPoint) {
        // Universal interaction began (touches, clicks, etc)
        // This method is a placeholder overridden by subclasses
        let sound = SKAction.playSoundFileNamed(k.Sounds.blop01, waitForCompletion: false)
        self.run(sound)
        
    }
    
    func userInteractionMoved(_ location: CGPoint) {
        // Universal interaction moved (touches, clicks, etc)
        // This method is a placeholder overridden by subclasses
    }
    
    func userInteractionEnded(_ location: CGPoint) {
        // Universal interaction ended (touches, clicks, etc)
        // This method is a placeholder overridden by subclasses
    }
    
}
