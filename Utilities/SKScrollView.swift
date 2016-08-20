//
//  SKScrollView.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

import SpriteKit

/// Scroll direction
enum ScrollDirection {
    case vertical // cases start with small letters as I am following swift 3 guidlines
    case horizontal
}

/// Custom UIScrollView class
class SKScrollView: UIScrollView {
    
    // MARK: - Static Properties
    
    private static var disabledTouches = false
    private static var scrollView: UIScrollView?
    
    // MARK: - Properties
    
    var currentScene: SKScene?
    private let moveableNode: SKNode
    private let scrollDirection: ScrollDirection
    private var nodesTouched = [AnyObject]() /// Nodes touched. This will forward touches to node subclasses.
    
    // MARK: - Init
    
    init(frame: CGRect, moveableNode: SKNode, scrollDirection: ScrollDirection, scene: SKScene?) {
        self.moveableNode = moveableNode
        self.scrollDirection = scrollDirection
        super.init(frame: frame)
        
        SKScrollView.scrollView = self
        
        currentScene = scene
        
        self.frame = frame
        delegate = self
        indicatorStyle = .White
        scrollEnabled = true
        userInteractionEnabled = true
        //canCancelContentTouches = false
        //minimumZoomScale = 1
        //maximumZoomScale = 3
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        if scrollDirection == .horizontal {
            transform = CGAffineTransformMakeScale(-1,1) // set 2nd number to -1 if you want scroll indicator at top
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Touches

extension SKScrollView {
    
    /// Began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.locationInNode(currentScene)
            
            guard !SKScrollView.disabledTouches else { return }
            
            currentScene.touchesBegan(touches, withEvent: event)
            nodesTouched = currentScene.nodesAtPoint(location)
            for node in nodesTouched {
                node.touchesBegan(touches, withEvent: event)
            }
        }
    }
    
    /// Moved
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.locationInNode(currentScene)
            
            guard !SKScrollView.disabledTouches else { return }
            
            currentScene.touchesMoved(touches, withEvent: event)
            nodesTouched = currentScene.nodesAtPoint(location)
            for node in nodesTouched {
                node.touchesMoved(touches, withEvent: event)
            }
        }
    }
    
    /// Ended
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.locationInNode(currentScene)
            
            guard !SKScrollView.disabledTouches else { return }
            
            currentScene.touchesEnded(touches, withEvent: event)
            nodesTouched = currentScene.nodesAtPoint(location)
            for node in nodesTouched {
                node.touchesEnded(touches, withEvent: event)
            }
        }
    }
    
    /// Cancelled
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches! {
            let location = touch.locationInNode(currentScene)
            
            guard !SKScrollView.disabledTouches else { return }
            
            currentScene.touchesCancelled(touches, withEvent: event)
            nodesTouched = currentScene.nodesAtPoint(location)
            for node in nodesTouched {
                node.touchesCancelled(touches, withEvent: event)
            }
        }
    }
}

// MARK: - Touch Controls

extension SKScrollView {
    
    class func disable() {
        SKScrollView.scrollView?.userInteractionEnabled = false
        SKScrollView.disabledTouches = true
    }
    
    class func enable() {
        SKScrollView.scrollView?.userInteractionEnabled = true
        SKScrollView.disabledTouches = false
    }
}

// MARK: - Delegates

extension SKScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollDirection == .horizontal {
            moveableNode.position.x = scrollView.contentOffset.x
        } else {
            moveableNode.position.y = scrollView.contentOffset.y
        }
    }
}
