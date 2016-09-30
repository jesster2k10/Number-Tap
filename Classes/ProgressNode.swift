//
//  CircularTimer.swift
//  Number Tap Universal
//
//  Created by Jesse on 19/08/2016.
//  Copyright © 2016 Denver Swift Heads. All rights reserved.
//

import SpriteKit

open class ProgressNode : SKShapeNode
{
    var pro = 0
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //  MARK: constants
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    struct Constants {
        static let radius : CGFloat          = 32
        static let color : SKColor           = SKColor.darkGray
        static let backgroundColor : SKColor = SKColor.lightGray
        static let width : CGFloat           = 2.0
        static var progress : CGFloat        = 0.0
        static let startAngle : CGFloat      = CGFloat(M_PI_2)
        static fileprivate let actionKey         = "_progressNodeCountdownActionKey"
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //  MARK: properties
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// the radius of the progress node
    open var radius: CGFloat = ProgressNode.Constants.radius {
        didSet {
            self.updateProgress(self.timeNode, progress: self.progress)
            self.updateProgress(self)
        }
    }
    
    //the active time color
    open var color: SKColor = ProgressNode.Constants.color {
        didSet {
            self.timeNode.strokeColor = self.color
        }
    }
    
    //the background color of the timer (to hide: use clear color)
    open var backgroundColor: SKColor = ProgressNode.Constants.backgroundColor {
        didSet {
            self.strokeColor = self.backgroundColor
        }
    }
    
    ///the line width of the progress node
    open var width: CGFloat = ProgressNode.Constants.width {
        didSet {
            self.timeNode.lineWidth = self.width
            self.lineWidth          = self.width
        }
    }
    
    //the current progress of the progress node end progress is 1.0 and start is 0.0
    open var progress: CGFloat = ProgressNode.Constants.progress {
        didSet {
            self.updateProgress(self.timeNode, progress: self.progress)
        }
    }
    
    // the start angle of the progress node
    open var startAngle: CGFloat = ProgressNode.Constants.startAngle {
        didSet {
            self.updateProgress(self.timeNode, progress: self.progress)
        }
    }
    
    fileprivate let timeNode = SKShapeNode()
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //  MARK: init
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    public init(radius: CGFloat,
                color: SKColor = ProgressNode.Constants.color,
                backgroundColor: SKColor = ProgressNode.Constants.backgroundColor,
                width: CGFloat = ProgressNode.Constants.width,
                progress: CGFloat = ProgressNode.Constants.progress) {
        
        self.radius          = radius
        self.color           = color
        self.backgroundColor = backgroundColor
        self.width           = width
        self.progress        = progress
        
        super.init()
        
        self._init()
    }
    
    override init() {
        super.init()
        
        self._init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self._init()
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //  MARK: helpers
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate func _init() {
        self.timeNode.lineWidth   = self.width
        self.timeNode.strokeColor = self.color
        self.timeNode.zPosition   = 10
        self.timeNode.position    = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(self.timeNode)
        self.updateProgress(self.timeNode, progress: self.progress)
        
        self.lineWidth   = self.width
        self.strokeColor = self.backgroundColor
        self.zPosition   = self.timeNode.zPosition
        
        self.updateProgress(self)
    }
    
    open func updateProgress(_ node: SKShapeNode, progress: CGFloat = 0.0) {
        let progress   = 1.0 - progress
        _ = CGFloat(M_PI / 2.0)
        let endAngle   = self.startAngle + progress*CGFloat(2.0*M_PI)
        node.path      = UIBezierPath(arcCenter: CGPoint.zero,
                                      radius: self.radius,
                                      startAngle: self.startAngle,
                                      endAngle: endAngle,
                                      clockwise: true).cgPath
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //  MARK: API
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    /*!
     The countdown method counts down from a time interval to zero,
     and it calls a callback on the main thread if its finished
     
     :param: time     The time interval to count
     :param: progressHandler   An optional callback method (always called on main thread)
     :param: callback An optional callback method (always called on main thread)
     */
    open func countdown(_ time: TimeInterval = 1.0, completionHandler: ((Void) -> Void)?) {
        self.countdown(time, progressHandler: nil, completionHandler: completionHandler)
    }
    
    open func countdown(_ time: TimeInterval = 1.0, progressHandler: ((Void) -> Void)?, completionHandler: ((Void) -> Void)?) {
        self.stopCountdown()
        
        self.run(SKAction.customAction(withDuration: time, actionBlock: {(node: SKNode!, elapsedTime: CGFloat) -> Void in
            self.progress = elapsedTime / CGFloat(time)
            
            if let cb = progressHandler {
                DispatchQueue.main.async(execute: {
                    cb()
                })
            }
            
            if self.progress == 1.0 {
                if let cb = completionHandler {
                    DispatchQueue.main.async(execute: {
                        cb()
                    })
                }
            }
        }), withKey:ProgressNode.Constants.actionKey)
    }
    
    open func stopCountdown() {
        self.removeAction(forKey: ProgressNode.Constants.actionKey)
    }
}
