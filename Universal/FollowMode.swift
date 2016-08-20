//
//  FollowMode.swift
//  Number Tap
//
//  Created by Jesse on 16/08/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import SpriteKit

class Follow: BaseScene {
    let followNode = SKNode()
    var cameraTimer = NSTimer()
    var cam = SKCameraNode()
    var world = SKNode()
    var firstBox = true
    var touchedBoxesArray = [NumberBox]()
    
    override func didMoveToView(view: SKView) {
        randomWord()
        start(kGameMode.kFollow, cam: nil)
        
        followNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        cam.position = followNode.position
        
        world.position = followNode.position
        addChild(world)
        world.addChild(cam)
        world.zPosition = 0
        
        camera = cam
        
        for box in boxArray {
            box.zPosition = -1
        }
        
        NSTimer.every(0.1) {
            self.followNode.position = CGPointMake(self.followNode.position.x, self.followNode.position.y + 1)
        }
    }
    
    func point(box: NumberBox) {
        box.darken()
        touchedBoxesArray.append(box)
        numbersTapped += 1
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for box in boxArray {
            point(box)
            if firstBox == true {
                firstBox = false
            }
        }
    }

    override func update(currentTime: NSTimeInterval) {
        cam.position.y = followNode.position.y
    }
}
