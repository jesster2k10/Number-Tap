//
//  DefaultScene.swift
//  Universal Game Template
//
//  Created by Matthew Fecher on 12/4/15.
//  Copyright © 2015 Denver Swift Heads. All rights reserved.
//

import SpriteKit

class InitScene: SKScene {
    
    // ****************************************************
    // MARK: - Universal User Interaction
    // ****************************************************
    
    // These top-level methods are enhanced by extensions
    // See the "Interaction Extensions" group.
    
    // iOS | tvOS | OS/X have different user interactions.
    // By abstracting out, it opens the door to easily add
    // interactions and platforms (e.g. such as OS/X mouse/keyboard)
    
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
