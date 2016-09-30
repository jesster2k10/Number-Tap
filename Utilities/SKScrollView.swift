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
    
    fileprivate static var disabledTouches = false
    fileprivate static var scrollView: UIScrollView?
    
    // MARK: - Properties
    
    var currentScene: SKScene?
    fileprivate let moveableNode: SKNode
    fileprivate let scrollDirection: ScrollDirection
    fileprivate var nodesTouched = [AnyObject]() /// Nodes touched. This will forward touches to node subclasses.
    
    // MARK: - Init
    
    init(frame: CGRect, moveableNode: SKNode, scrollDirection: ScrollDirection, scene: SKScene?) {
        self.moveableNode = moveableNode
        self.scrollDirection = scrollDirection
        super.init(frame: frame)
        
        SKScrollView.scrollView = self
        
        currentScene = scene
        
        self.frame = frame
        delegate = self
        indicatorStyle = .white
        isScrollEnabled = true
        isUserInteractionEnabled = true
        //canCancelContentTouches = false
        //minimumZoomScale = 1
        //maximumZoomScale = 3
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        if scrollDirection == .horizontal {
            transform = CGAffineTransform(scaleX: -1,y: 1) // set 2nd number to -1 if you want scroll indicator at top
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Touches

extension SKScrollView {
    
    /// Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
            
            guard !SKScrollView.disabledTouches else { return }
            
            currentScene.touchesBegan(touches, with: event)
            nodesTouched = currentScene.nodes(at: location)
            for node in nodesTouched {
                node.touchesBegan(touches, with: event)
            }
        }
    }
    
    /// Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
            
            guard !SKScrollView.disabledTouches else { return }
            
            currentScene.touchesMoved(touches, with: event)
            nodesTouched = currentScene.nodes(at: location)
            for node in nodesTouched {
                node.touchesMoved(touches, with: event)
            }
        }
    }
    
    /// Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
            
            guard !SKScrollView.disabledTouches else { return }
            
            currentScene.touchesEnded(touches, with: event)
            nodesTouched = currentScene.nodes(at: location)
            for node in nodesTouched {
                node.touchesEnded(touches, with: event)
            }
        }
    }
    
    /// Cancelled
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        guard let currentScene = currentScene else { return }
        
        for touch in touches {
            let location = touch.location(in: currentScene)
            
            guard !SKScrollView.disabledTouches else { return }
            
            currentScene.touchesCancelled(touches, with: event)
            nodesTouched = currentScene.nodes(at: location)
            for node in nodesTouched {
                node.touchesCancelled(touches, with: event)
            }
        }
    }
}

// MARK: - Touch Controls

extension SKScrollView {
    
    class func disable() {
        SKScrollView.scrollView?.isUserInteractionEnabled = false
        SKScrollView.disabledTouches = true
    }
    
    class func enable() {
        SKScrollView.scrollView?.isUserInteractionEnabled = true
        SKScrollView.disabledTouches = false
    }
}

// MARK: - Delegates

extension SKScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollDirection == .horizontal {
            moveableNode.position.x = scrollView.contentOffset.x
        } else {
            moveableNode.position.y = scrollView.contentOffset.y
        }
    }
}
