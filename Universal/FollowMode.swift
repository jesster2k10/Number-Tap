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
    var cameraTimer = Timer()
    var cam = SKCameraNode()
    var world = SKNode()
    var firstBox = true
    var touchedBoxesArray = [NumberBox]()
    
    override func didMove(to view: SKView) {
        randomWord()
        start(kGameMode.kFollow, cam: nil)
        
        followNode.position = CGPoint(x: frame.midX, y: frame.midY)
        cam.position = followNode.position
        
        world.position = followNode.position
        addChild(world)
        world.addChild(cam)
        world.zPosition = 0
        
        camera = cam
        
        for box in boxArray {
            box.zPosition = -1
        }
        
        Timer.every(0.1) {
            self.followNode.position = CGPoint(x: self.followNode.position.x, y: self.followNode.position.y + 1)
        }
    }
    
    func point(_ box: NumberBox) {
        box.darken()
        touchedBoxesArray.append(box)
        numbersTapped += 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for box in boxArray {
            point(box)
            if firstBox == true {
                firstBox = false
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        cam.position.y = followNode.position.y
    }
}
