//
//  NSTimerEx.swift
//  Number Tap Universal
//
//  Created by Jesse on 20/08/2016.
//  Copyright © 2016 Flatbox Studio. All rights reserved.
//

class TimerArrayHelper: NSObject {
    static let sharedHelper = TimerArrayHelper()
    var timerArray : [Timer] = [Timer]()
    var backgroundTimer = false
    
    override init() {
    }
    
    func initHelper() {
        timerArray = []
    }
    
    func addTheTimer(timer: Timer) {
        timerArray.append(timer)
    }
    
    func aPauseAllTimers() {
        for timer in timerArray {
            timer.invalidate()
        }
    }
    
    func aResumeAllTimers() {
        for timer in timerArray {
            timer.fire()
        }
    }
    
    func aRemoveTimer(timer: Timer) {
        for object in timerArray
        {
            if object == timer {
                timerArray.remove(at: timerArray.index(of: timer)!)
            }
        }
    }
    
    func aSetBackgroundTimer(bg: Bool) {
        backgroundTimer = bg
    }
    
}
extension Timer {
    
    // MARK: Timer Arrays
    public class func initArray () {
        let helper = TimerArrayHelper()
        helper.initHelper()
    }
    
    public class func addTimer(timer: Timer) {
        TimerArrayHelper.sharedHelper.addTheTimer(timer: timer)
    }
    
    public class func removeTimer(timer: Timer) {
        TimerArrayHelper.sharedHelper.aRemoveTimer(timer: timer)
    }
    
    public class func pauseAllTimers() {
        TimerArrayHelper.sharedHelper.aPauseAllTimers()
    }
    
    public class func resumeAllTimers() {
        TimerArrayHelper.sharedHelper.aResumeAllTimers()
    }
    
    public class func setBackgroundTimer(bg: Bool) {
        TimerArrayHelper.sharedHelper.backgroundTimer = bg
    }
    
    // MARK: Schedule timers
    
    /// Create and schedule a timer that will call `block` once after the specified time.
    
    public class func after(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        let timer = Timer.new(after: interval, block)
        if TimerArrayHelper.sharedHelper.backgroundTimer == false {
            addTimer(timer: timer)
        }
        timer.start()
        return timer
    }
    
    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.
    
    public class func every(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        let timer = Timer.new(every: interval, block)
        if TimerArrayHelper.sharedHelper.backgroundTimer == false {
            addTimer(timer: timer)
        }
        timer.start()
        return timer
    }
    
    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.
    /// (This variant also passes the timer instance to the block)
    
    @nonobjc public class func every(_ interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
        let timer = Timer.new(every: interval, block)
        if TimerArrayHelper.sharedHelper.backgroundTimer == false {
            addTimer(timer: timer)
        }
        timer.start()
        return timer
    }
    
    // MARK: Create timers without scheduling
    
    /// Create a timer that will call `block` once after the specified time.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.after` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)
    
    public class func new(after interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, 0, 0, 0) { _ in
            block()
        }
    }
    
    /// Create a timer that will call `block` repeatedly in specified time intervals.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)
    
    public class func new(every interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block()
        }
    }
    
    /// Create a timer that will call `block` repeatedly in specified time intervals.
    /// (This variant also passes the timer instance to the block)
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    /// - Note: The `new` class function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)
    
    @nonobjc public class func new(every interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
        var timer: Timer!
        timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block(timer)
        }
        return timer
    }
    
    // MARK: Manual scheduling
    
    /// Schedule this timer on the run loop
    ///
    /// By default, the timer is scheduled on the current run loop for the default mode.
    /// Specify `runLoop` or `modes` to override these defaults.
    
    public func start(runLoop: RunLoop = RunLoop.current, modes: String...) {
        let modes = modes.isEmpty ? [RunLoopMode.defaultRunLoopMode] : [modes]
        
        for mode in modes {
            runLoop.add(self, forMode: mode as! RunLoopMode)
        }
    }
}
