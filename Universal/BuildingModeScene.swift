//
//  BuildingModeScene.swift
//  Number Tap
//
//  Created by jesse on 09/06/2016.
//  Copyright © 2016 FlatBox Studio. All rights reserved.
//

import UIKit
import SpriteKit

class BuildUp: BaseScene {
    var touchableArray = [NumberBox]()
    var spareArray = [Int]()
    var tutorial = 0
    
    //TODO: Create an invisible node that moves up the screen as the game goes on. The camera will follow this node. As the game goes on the camera moves faster. You must tao the number before the camera looses it. Name this mode mooving - 
    override func didMove(to view: SKView) {
        addChild(background)
        
        setupBoxes()
    }
    
    func setupBoxes() {
        randomWord()
        
        for i in 1 ..< 50 {
            var posY : CGFloat = 700
            var posX : CGFloat = 170
            let index = i - 1
            
            switch i {
            case let i where i == 1 || i == 2 || i == 3  || i == 4 :
                posY = 700
                break;
            case let i where i == 5 || i == 6 || i == 7  || i == 8 :
                posY = 600
                break;
            case let i where i == 9 || i == 10 || i == 11  || i == 12 :
                posY = 500
                break;
            case let i where i == 13 || i == 14 || i == 15  || i == 16 :
                posY = 400
                break;
            case let i where i == 17 || i == 18 || i == 19  || i == 20 :
                posY = 300
                break;
            case let i where i == 21 || i == 22 || i == 23  || i == 24 :
                posY = 200
                break;
                
            default:
                posY = 700
                break;
            }
            
            if i == 1 || i == 5 || i == 9 || i == 13 || i == 17 || i == 21 {
                posX = 170
            };
            
            if i == 2 || i == 6 || i == 10 || i == 14 || i == 18 || i == 22 {
                posX = 270
            };
            
            if i == 3 || i == 7 || i == 11 || i == 15 || i == 19 || i == 23 {
                posX = 370
            };
            
            if i == 4 || i == 8 || i == 12 || i == 16 || i == 20 || i == 24 {
                posX = 470
            }
            
            let box = NumberBox(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 500) , index: nil)
            box.position = CGPoint(x: posX, y: posY)
            box.zPosition = background.zPosition + 1
            box.name = "numberBox" + String(i)
            box.indexs = array[index]
            box.index = i
            addChild(box)
            
            boxArray.append(box)
            
            print("\n\n\n Yea yea X \(posX) & Y \(posY) for box number \(i) \n\n\n")
            
        }
        
        randomBoxFromArray(boxesArray: boxArray, howManyBoxes: 1)
    }
    
    //MARK: Game Logic
    func makeBoxVisible(_ box: NumberBox) {
        box.alpha = 1
        box.scaleToSmallerSize()
        touchableArray.append(box)
    }
    
    func randomBoxFromArray(boxesArray array: [NumberBox], howManyBoxes howMuch: Int) {
        for _ in 0 ..< howMuch {
            let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
            let randomBox = array[randomIndex]
            
            makeBoxVisible(randomBox)
        }
    }
    
    //MARK: Touch methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            handleTouchedPoint(location)
        }
    }
    
    override func handleTouchedPoint(_ location: CGPoint) {
        for touchableBox in touchableArray {
            touchableBox.flip()
            //touchableBox.indexs = spareArray[touchableBox.index]
            touchableBox.update()
            touchableBox.reFlip()
            let randomNumber = Int(arc4random_uniform(3) + 1)
            randomBoxFromArray(boxesArray: boxArray, howManyBoxes: randomNumber)
        }
    }
}
